//
//  DefaultPhotoClusterService.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

final class DefaultPhotoClusterService: PhotoClusterService {
    func clusterPhotos(_ photos: [PHAsset]) -> [PhotoCluster] {
        // FIXME: 실제 클러스터 로직 구현필요
        return [ // mock data
            .init(id: UUID(), title: "Jeju Trip", phAssets: photos),
            .init(id: UUID(), title: "Jeju Trip2", phAssets: photos),
            .init(id: UUID(), title: "Jeju Trip3", phAssets: photos),
            .init(id: UUID(), title: "Jeju Trip4", phAssets: photos),
            .init(id: UUID(), title: "Jeju Trip5", phAssets: photos)
        ]
    }
}
