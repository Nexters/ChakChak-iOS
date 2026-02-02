//
//  PhotoSelectView.swift
//  Chac
//
//  Created by 가은 on 1/15/26.
//

import SwiftUI
import Photos

struct PhotoSelectView: View {

    private enum Strings {
        static let selectAll = "전체 선택"
        static let selectPhoto = "사진 선택"
        static let selectPhotoDescription = "사진을 선택해주세요"
    }
    
    private enum Metric {
        static let horizontalPadding: CGFloat = 20
        static let thumbnailSize: CGFloat = (UIScreen.main.bounds.width - (Metric.horizontalPadding * 2)) / 3
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var moveToPhotoSaveView = false
    @State private var moveToPhotoDetailView = false
    @State private var longPressedAsset: PHAsset?
    @State private var selectedAssets: Set<PHAsset> = []
    @State private var savedCount = 0
    
    let cluster: PhotoCluster
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(cluster.title)
                        .font(.title2)
                        .lineLimit(2)
                    
                    Text("\(selectedAssets.count)/\(cluster.phAssets.count) 선택")
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Button {
                    selectAllAssets()
                } label: {
                    Text(Strings.selectAll)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray)
                        )
                }
                .foregroundStyle(.gray)

            }
            .padding(.horizontal, Metric.horizontalPadding)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cluster.phAssets, id: \.localIdentifier) { phAsset in
                        PhotoThumbnailView(
                            phAsset: phAsset,
                            targetSize: CGSize(width: Metric.thumbnailSize, height: Metric.thumbnailSize),
                            isSelected: selectedAssets.contains(phAsset)
                        )
                        .onTapGesture {
                            toggleSelection(for: phAsset)
                        }
                        .onLongPressGesture(minimumDuration: 0.3) {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            longPressedAsset = phAsset
                            moveToPhotoDetailView = true
                        }
                    }
                }
                .padding(.horizontal, Metric.horizontalPadding)
            }
            
            Button {
            } label: {
                Text(selectedAssets.isEmpty
                    ? Strings.selectPhotoDescription
                    : "\(selectedAssets.count)장의 사진 앨범에 저장")
                .foregroundStyle(.black.opacity(0.7))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedAssets.isEmpty ? .gray.opacity(0.3) : .gray.opacity(0.6))
                )
            }
            .disabled(selectedAssets.isEmpty)
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, 10)
            .background(.white)
            
        }
        .padding(.top, 12)
        .navigationTitle(Strings.selectPhoto)
        .fullScreenCover(isPresented: $moveToPhotoSaveView) {
            PhotoSaveView(savedCount: savedCount)
        }
        .fullScreenCover(isPresented: $moveToPhotoDetailView) {
            PhotoDetailView(phAsset: $longPressedAsset)
        }
    }
    
    private func toggleSelection(for asset: PHAsset) {
        if selectedAssets.contains(asset) {
            selectedAssets.remove(asset)
        } else {
            selectedAssets.insert(asset)
        }
    }
    
    private func selectAllAssets() {
        if selectedAssets.count == cluster.phAssets.count {
            selectedAssets.removeAll()
        } else {
            selectedAssets = Set(cluster.phAssets)
        }
    }
}

//#Preview {
//    PhotoSelectView()
//        .environmentObject(PhotoLibraryStore())
//}
