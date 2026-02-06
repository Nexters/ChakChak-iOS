//
//  PhotoThumbnailView.swift
//  Chac
//
//  Created by 이원빈 on 1/24/26.
//

import SwiftUI
import Photos

struct PhotoThumbnailView: View {
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var image: UIImage?
    
    let phAsset: PHAsset
    let targetSize: CGSize
    var isSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.gray.opacity(0.3))
                        .overlay {
                            ProgressView()
                        }
                }
            }
            .frame(width: targetSize.width, height: targetSize.height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .contentShape(Rectangle())
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle" )
                .foregroundStyle(isSelected ? .blue : .white)
                .padding(5)
        }
        .task {
            await loadThumbnailIfNeeded()
        }
    }
    
    private func loadThumbnailIfNeeded() async {
        guard image == nil else { return }
        
        do {
            image = try await photoLibraryStore.requestThumbnail(for: phAsset, targetSize: targetSize)
        } catch {
            print("Failed to load thumbnail: \(error.localizedDescription)")
        }
    }
}
