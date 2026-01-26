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
    let phAssets: [PHAsset]
}

extension PhotoCluster {
    func toViewModel() -> ClusterCellModel {
        ClusterCellModel(
            thumbnailPHAsset: phAssets.first ?? PHAsset(),
            title: title,
            photoCount: phAssets.count
        )
    }
}
