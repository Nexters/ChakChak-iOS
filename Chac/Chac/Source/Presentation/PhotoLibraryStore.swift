import Foundation
import Photos
import UIKit
import SwiftUI

@MainActor
final class PhotoLibraryStore: ObservableObject {
    @Published private(set) var photos: [PHAsset] = []
    @Published private(set) var clusters: [PhotoCluster] = []
    @Published var isLoading: Bool = false
    
    private var isFirstLoad = true
    private let libraryService: PhotoLibraryService
    private let clusterService: PhotoClusterService
    
    init(
        libraryService: PhotoLibraryService = DefaultPhotoLibraryService(),
        clusterService: PhotoClusterService = DefaultPhotoClusterService()
    ) {
        self.libraryService = libraryService
        self.clusterService = clusterService
    }
    
    func refreshIfAuthorized(status: PHAuthorizationStatus) {
        guard status == .authorized || status == .limited else { return }
        guard isLoading == false, isFirstLoad == true else { return }
        isLoading = true
        isFirstLoad = false
        
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000) // FIXME: 앨범 생성중... 화면 표출 시간 3초 강제 -> 논의 후 변경
            let fetched = await Task(priority: .userInitiated) {
                libraryService.fetchAllImages()
            }.value
            
            self.photos = fetched
            await processClustering()
            
        }
    }
    
    func requestThumbnail(for asset: PHAsset, targetSize: CGSize) async throws -> UIImage {
        return try await libraryService.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill)
    }
    
    func saveToAlbum(assets: [PHAsset], albumName: String) async throws {
        try await libraryService.saveToAlbum(assets: assets, albumName: albumName)
    }
    
    private func processClustering() async {
        guard !photos.isEmpty else { return }
        
        Task(priority: .utility) {  // UI보다 낮은 우선순위
            let stream = clusterService.clusterPhotos(photos)
            
            for await newCluster in stream {
                await MainActor.run {
                    withAnimation(.easeIn) {
                        self.clusters.append(newCluster)
                    }
                }
                
                try? await Task.sleep(for: .seconds(0.2))
            }
            self.isLoading = false
        }
    }
}
