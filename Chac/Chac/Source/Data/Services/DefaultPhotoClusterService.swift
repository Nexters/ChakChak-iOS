//
//  DefaultPhotoClusterService.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

final class DefaultPhotoClusterService: PhotoClusterService {
    private let timeService: ClusteringStrategy
    private let locationService: ClusteringStrategy
    
    init(
        timeService: ClusteringStrategy = TimeClusteringService(),
        locationService: ClusteringStrategy = LocationClusteringService()
    ) {
        self.timeService = timeService
        self.locationService = locationService
    }
    
    /// 두 가지 전략을 순차적으로 적용하여 최종 클러스터를 생성합니다
    func clusterPhotos(_ photos: [PHAsset]) async -> [PhotoCluster] {
        
        // 시간으로 그룹화
        let timeGroups = await timeService.cluster(assets: photos)
        
        // 병렬 처리를 위한 TaskGroup
        return await withTaskGroup(of: [PhotoCluster].self) { group in
            for timeGroup in timeGroups {
                // 각 시간 그룹마다 새로운 자식 Task 추가
                group.addTask {
                    // 공간 기반 2차 그룹화
                    let locationGroups = await self.locationService.cluster(assets: timeGroup)
                    
                    var clustersInTimeGroup: [PhotoCluster] = []
                    
                    for locGroup in locationGroups {
                        guard let location = locGroup.first?.location else { continue }
                        
                        // TODO: 위치 이름 가져오는 로직 필요
                        let title = "서울 도봉구"
                        
                        clustersInTimeGroup.append(PhotoCluster(id: UUID(), title: title, phAssets: locGroup))
                    }
                    
                    return clustersInTimeGroup
                }
            }
            
            var results: [PhotoCluster] = []
            
            // 병렬 작업이 끝나는 순서대로 결과 수집
            for await clusterGroup in group {
                results.append(contentsOf: clusterGroup)
            }
            
            return results
        }
    }
    
}
