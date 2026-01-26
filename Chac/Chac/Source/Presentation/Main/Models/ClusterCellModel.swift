//
//  ClusterCellModel.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

struct ClusterCellModel {
    let thumbnailPHAsset: PHAsset
    let title: String
    let photoCount: Int
}

extension ClusterCellModel {
    static func stub(
        thumbnailImage: PHAsset = PHAsset(),
        title: String = "Jeju Trip",
        photoCount: Int = 32
    ) -> Self {
        .init(
            thumbnailPHAsset: thumbnailImage,
            title: title,
            photoCount: photoCount
        )
    }
}
