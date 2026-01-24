//
//  PhotoCluster.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Foundation
import Photos

struct PhotoCluster {
    let id: UUID
    let title: String
    let photoAssets: [PhotoAsset]
}

extension PhotoCluster {
    func toViewModel() -> ClusterCellViewModel {
        ClusterCellViewModel(
            thumbnailPHAsset: photoAssets.first?.phAsset ?? PHAsset(),
            title: title,
            photoCount: photoAssets.count
        )
    }
}
