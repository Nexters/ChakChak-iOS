//
//  PhotoLibraryService.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

import UIKit
import Photos

protocol PhotoLibraryService {
    func fetchAllImages() -> [PhotoAsset]
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) async throws -> UIImage
}
