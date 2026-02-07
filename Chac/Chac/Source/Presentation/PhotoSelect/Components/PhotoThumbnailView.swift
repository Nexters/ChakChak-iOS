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
        ZStack(alignment: .bottomTrailing) {
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPressed ? Color.black.opacity(0.6) : .clear)
                    .stroke(isPressed ? ColorPalette.stroke_01 : .clear, lineWidth: 1)
            }
            
            Image("check_icon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(isSelected ? ColorPalette.text_01 : ColorPalette.text_03)
                .background(
                    Circle()
                        .fill(isPressed ? ColorPalette.primary : ColorPalette.black_40)
                        .stroke(isPressed ? ColorPalette.stroke_03 : .clear, style: .init(lineWidth: 1))
                        .frame(width: 20, height: 20)
                )
                .padding(10)
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
