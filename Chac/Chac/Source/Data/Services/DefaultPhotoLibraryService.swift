//
//  DefaultPhotoLibraryService.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

import Photos
import UIKit

final class DefaultPhotoLibraryService: PhotoLibraryService {
    private let imageManager: PHCachingImageManager
    
    init(imageManager: PHCachingImageManager = PHCachingImageManager()) {
        self.imageManager = imageManager
    }
    
    func fetchAllImages() -> [PHAsset] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        var result: [PHAsset] = []
        
        fetchResult.enumerateObjects { asset, _, _ in
            result.append(asset)
        }
        return result
    }
    
    func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        contentMode: PHImageContentMode = .aspectFill,
    ) async throws -> UIImage {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat /// 변경 될 경우 isDegraded 체크 필요
        
        return try await withCheckedThrowingContinuation { continuation in
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: contentMode,
                options: options
            ) { image, info in
                let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                guard !isDegraded else { return }
                
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: PhotoLibraryError.underlying(error))
                } else if let cancelled = info?[PHImageCancelledKey] as? Bool, cancelled {
                    continuation.resume(throwing: PhotoLibraryError.cancelled)
                    return
                } else if let image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: PhotoLibraryError.imageNotFound)
                }
            }
        }
    }
    
    func saveToAlbum(assets: [PHAsset], albumName: String) async throws {
        guard !assets.isEmpty else { return }
        
        // 새 앨범 생성 및 사진 추가
        try await PHPhotoLibrary.shared().performChanges {
            let createRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            createRequest.addAssets(assets as NSArray)
        }
    }
}
