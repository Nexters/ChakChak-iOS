//
//  PhotoClusterService.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import Photos

protocol PhotoClusterService {
    func clusterPhotos(_ photos: [PHAsset]) -> [PhotoCluster]
}
