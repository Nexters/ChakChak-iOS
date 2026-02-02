//
//  PhotoLibraryService.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

import UIKit
import Photos

protocol PhotoLibraryService {
    func fetchAllImages() -> [PHAsset]
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) async throws -> UIImage
    
    /// 선택된 사진들을 앨범에 저장합니다.
    /// - Returns: 저장된 사진 개수
    func saveToAlbum(assets: [PHAsset], albumName: String) async throws -> Int
}
