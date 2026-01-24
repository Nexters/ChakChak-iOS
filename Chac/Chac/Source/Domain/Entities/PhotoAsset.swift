//
//  PhotoAsset.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

import Photos

struct PhotoAsset: Identifiable {
    let id: String
    let phAsset: PHAsset
    let creationDate: Date?
    let location: CLLocation?
}
