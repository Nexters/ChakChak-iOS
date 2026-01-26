import Foundation
import Photos
import UIKit

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
            processClustering()
            self.isLoading = false
        }
    }
    
    func requestThumbnail(for asset: PHAsset, targetSize: CGSize) async throws -> UIImage {
        return try await libraryService.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill)
    }
    
    private func processClustering() {
        guard !photos.isEmpty else { return }
        let clusters = clusterService.clusterPhotos(photos)
        self.clusters = clusters
    }
}
