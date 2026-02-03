//
//  DefaultPhotoClusterService.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

final class DefaultPhotoClusterService: PhotoClusterService {
    private let timeService: StreamingStrategy
    private let locationService: ClusteringStrategy
    private let geocodingService: GeocodingService
    
    init(
        timeService: StreamingStrategy = TimeClusteringService(),
        locationService: ClusteringStrategy = LocationClusteringService(),
        geocodingService: GeocodingService = DefaultGeocodingService()
    ) {
        self.timeService = timeService
        self.locationService = locationService
        self.geocodingService = geocodingService
    }
    
    /// 두 가지 전략을 순차적으로 적용하여 최종 클러스터를 생성합니다
    func clusterPhotos(_ photos: [PHAsset]) -> AsyncStream<PhotoCluster> {
        AsyncStream { continuation in
            Task {
                let timeGroups = timeService.cluster(assets: photos)
                
                await withTaskGroup(of: Void.self) { group in
                    var activeTasks = 0
                    let maxTasks = 1
                    
                    for await timeGroup in timeGroups {
                        if activeTasks >= maxTasks {
                            await group.next()
                            activeTasks -= 1
                        }
                        
                        activeTasks += 1
                        
                        group.addTask {
                            let locationGroups = self.locationService.cluster(assets: timeGroup)
                            
                            for locGroup in locationGroups {
                                guard let location = locGroup.first?.location else { continue }
                                
                                let title = await self.geocodingService.fetchLocationName(from: location)
                                let newCluster = PhotoCluster(id: UUID(), title: title, phAssets: locGroup)
                                continuation.yield(newCluster)
                            }
                        }
                    }
                }
                
                continuation.finish()
            }
        }
    }
}
