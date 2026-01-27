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
        
        // 장소로 다시 그룹화
        var allLocationGroups: [[PHAsset]] = []
        for group in timeGroups {
            let locationGroups = await locationService.cluster(assets: group)
            allLocationGroups.append(contentsOf: locationGroups)
        }
        
        // 병렬 처리
        return await withTaskGroup(of: PhotoCluster?.self) { group in
            for locGroup in allLocationGroups {
                group.addTask {
                    // 클러스터의 첫 번째 사진의 위치로 측정
                    guard let location = locGroup.first?.location else { return nil }
                    
                    // TODO: 위치 이름 가져오는 로직 필요
                    let title = "서울 도봉구"
                    
                    return PhotoCluster(id: UUID(), title: title, phAssets: locGroup)
                }
            }
            
            var results: [PhotoCluster] = []
            for await cluster in group {
                if let cluster = cluster {
                    results.append(cluster)
                }
            }
            
            return results
        }
    }
    
}
