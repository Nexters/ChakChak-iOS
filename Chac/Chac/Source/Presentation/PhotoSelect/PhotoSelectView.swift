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
        static let cancelSelectAll = "전체 해제"
        static let selectPhoto = "사진 정리"
        static let selectPhotoDescription = "사진을 선택해주세요"
    }
    
    private enum Metric {
        static let horizontalPadding: CGFloat = 20
        static let thumbnailSize: CGFloat = (UIScreen.main.bounds.width - (Metric.horizontalPadding * 3)) / 3
    }
    
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var moveToPhotoSaveView = false
    @State private var moveToPhotoDetailView = false
    @State private var longPressedAsset: PHAsset?
    @State private var isSelectAll: Bool = false
    @State private var selectedAssets: Set<PHAsset> = []
    @State private var savedCount = 0
    
    let cluster: PhotoCluster
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(cluster: PhotoCluster) {
        self.cluster = cluster
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(cgColor: ColorPalette.background.cgColor!)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(cluster.title)
                    .chacFont(.sub_title_01)
                    .foregroundStyle(ColorPalette.text_01)
                    .lineLimit(2)
                
                Spacer()
                
                Button {
                    selectAllAssets()
                } label: {
                    Text(isSelectAll ? Strings.cancelSelectAll : Strings.selectAll)
                        .chacFont(.caption)
                        .foregroundStyle(isSelectAll ? ColorPalette.text_02 : ColorPalette.text_04)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 9999)
                                .fill(ColorPalette.background_popup)
                                .stroke(
                                    isSelectAll ? ColorPalette.stroke_01 : .clear,
                                    style: .init(lineWidth: 1)
                                )
                        )
                }
            }
            .padding(.horizontal, Metric.horizontalPadding)
            
            HStack(spacing: 5) {
                Spacer()
                Text("\(selectedAssets.count)")
                    .chacFont(.number)
                    .foregroundStyle(ColorPalette.text_02)
                
                RoundedRectangle(cornerRadius: 2)
                        .fill(ColorPalette.etc)
                        .frame(width: 1.5, height: 10)
                        .rotationEffect(.degrees(30))
                
                Text("\(cluster.phAssets.count)")
                    .chacFont(.number)
                    .foregroundStyle(ColorPalette.text_02)
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.top, 16)
            
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
            .padding(.top, 8)
            
            Button {
                Task {
                    await savePhotos()
                }
            } label: {
                Text(selectedAssets.isEmpty ? Strings.selectPhotoDescription : "\(selectedAssets.count)장의 사진 앨범에 저장")
                    .chacFont(.btn)
                    .foregroundStyle(selectedAssets.isEmpty ? ColorPalette.text_btn_03 : ColorPalette.text_btn_01)
                    .padding(.vertical, 17.5)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedAssets.isEmpty ? ColorPalette.disable : ColorPalette.primary)
                    )
            }
            .disabled(selectedAssets.isEmpty)
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.top, Metric.horizontalPadding)
        }
        .padding(.top, 12)
        .background(ColorPalette.background)
        .navigationTitle(Strings.selectPhoto)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $moveToPhotoSaveView) {
            PhotoSaveView(savedCount: $savedCount)
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
            isSelectAll = false
        } else {
            selectedAssets = Set(cluster.phAssets)
            isSelectAll = true
        }
    }
    
    private func savePhotos() async {
        do {
            try await photoLibraryStore.saveToAlbum(
                assets: Array(selectedAssets),
                albumName: cluster.title
            )
            savedCount = selectedAssets.count
            moveToPhotoSaveView = true
        } catch {
            print("앨범 저장 실패: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    PhotoSelectView()
//        .environmentObject(PhotoLibraryStore())
//}
