import Foundation
import Photos
import UIKit
import SwiftUI

@MainActor
final class PhotoLibraryStore: ObservableObject {
    @Published private(set) var photos: [PHAsset] = []
    @Published private(set) var clusters: [PhotoCluster] = []
    @Published var isLoading: Bool = false
    
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
        guard isLoading == false else { return }
        isLoading = true
        
        Task {
            let fetched = await Task(priority: .userInitiated) {
                libraryService.fetchAllImages()
            }.value
            
            self.photos = fetched
            await processClustering()
            self.isLoading = false
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
        }
    }
}
