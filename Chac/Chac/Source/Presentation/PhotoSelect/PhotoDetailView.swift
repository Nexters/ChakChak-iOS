//
//  PhotoDetailView.swift
//  Chac
//
//  Created by 가은 on 1/16/26.
//

import SwiftUI
import Photos

struct PhotoDetailView: View {
    private enum Metric {
        static let targetWidth: CGFloat = UIScreen.main.bounds.width
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @Environment(\.dismiss) var dismiss
    
    @Binding var phAsset: PHAsset?
    @State private var image: UIImage?
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            ZStack {
                Color.clear
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white)
                            .overlay {
                                ProgressView()
                            }
                    }
                }
            }
        }
        .task {
            await loadThumbnailIfNeeded()
        }
    }
    
    private func loadThumbnailIfNeeded() async {
        guard image == nil, let phAsset else { return }
        
        do {
            image = try await photoLibraryStore.requestThumbnail(
                for: phAsset,
                targetSize: CGSize(width: Metric.targetWidth, height: Metric.targetWidth)
            )
        } catch {
            print("Failed to load thumbnail: \(error.localizedDescription)")
        }
    }
}

#Preview {
    PhotoDetailView(phAsset: .constant(nil))
}

extension PHAsset {
    var aspectRatio: CGFloat {
        guard pixelHeight > 0 else { return 1.0 }
        return CGFloat(pixelWidth) / CGFloat(pixelHeight)
    }
}
