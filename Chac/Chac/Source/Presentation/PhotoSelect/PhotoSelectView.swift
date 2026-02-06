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
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(cgColor: ColorPalette.background.cgColor!)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text("서울 광진구광진구 광진구광진구광진구광진구") // FIXME: 앨범 제목 주입
                    .chacFont(.sub_title_01)
                    .foregroundStyle(ColorPalette.text_01)
                    .lineLimit(2)
                Spacer()
                Button {
                    isSelectAll.toggle()
                    // TODO: 전체선택 액션
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
                Text("0") // 선택된 수
                    .chacFont(.number)
                    .foregroundStyle(ColorPalette.text_02)
                
                RoundedRectangle(cornerRadius: 2)
                        .fill(ColorPalette.etc)
                        .frame(width: 1.5, height: 10)
                        .rotationEffect(.degrees(30))
                
                Text("\(photoLibraryStore.photos.count)")
                    .chacFont(.number)
                    .foregroundStyle(ColorPalette.text_02)
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.top, 16)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(photoLibraryStore.photos, id: \.localIdentifier) { phAsset in
                        PhotoThumbnailView(
                            phAsset: phAsset,
                            targetSize: CGSize(width: Metric.thumbnailSize, height: Metric.thumbnailSize)
                        )
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
                moveToPhotoSaveView = true
            } label: {
                Text(Strings.selectPhotoDescription) // TODO: 활성화 text: "\(n)장의 사진 앨범에 저장"
                    .chacFont(.btn)
                    .foregroundStyle(ColorPalette.text_btn_03)// TODO: 활성화 색상 text_btn_03
                    .padding(.vertical, 17.5)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorPalette.disable) // TODO: 활성화 색상 primary
                    )
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.top, Metric.horizontalPadding)
        }
        .padding(.top, 12)
        .background(ColorPalette.background)
        .navigationTitle(Strings.selectPhoto)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $moveToPhotoSaveView) {
            PhotoSaveView()
        }
        .fullScreenCover(isPresented: $moveToPhotoDetailView) {
            PhotoDetailView(phAsset: $longPressedAsset)
        }
    }
}

#Preview {
    PhotoSelectView()
        .environmentObject(PhotoLibraryStore())
}
