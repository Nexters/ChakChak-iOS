//
//  ClusterCellViewModel.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

struct ClusterCellViewModel {
    let thumbnailPHAsset: PHAsset
    let title: String
    let photoCount: Int
}

extension ClusterCellViewModel {
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
