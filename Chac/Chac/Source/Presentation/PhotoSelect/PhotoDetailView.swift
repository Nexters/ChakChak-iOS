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
    
    @State private var image: UIImage?
    @Binding var phAsset: PHAsset?
    let title: String
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .chacFont(.sub_title_03)
                        .foregroundStyle(ColorPalette.text_02)
                    Text("\(DateFormatter.mmDDhhMM.string(from: phAsset?.creationDate ?? Date()))")
                        .chacFont(.caption)
                        .foregroundStyle(ColorPalette.text_04)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(ColorPalette.text_01)
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
        .background(ColorPalette.background)
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
    PhotoDetailView(phAsset: .constant(nil), title: "부산")
}

extension PHAsset {
    var aspectRatio: CGFloat {
        guard pixelHeight > 0 else { return 1.0 }
        return CGFloat(pixelWidth) / CGFloat(pixelHeight)
    }
}
