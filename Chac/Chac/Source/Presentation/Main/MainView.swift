//
//  MainView.swift
//  Chac
//
//  Created by 이원빈 on 1/13/26.
//


import SwiftUI
import Photos

struct MainView: View {
    
    private enum Strings {
        static let topGreeting = "오늘도 착착착\n사진을 정리해 볼까요?"
        static let allPhotos = "모든 사진"
        static let createAlbum = "앨범 생성"
        static let permissionAlertTitle = "앨범 접근 권한"
        static let permissionAlertMessage = "앨범에 접근하려면 사진 접근 권한이 필요합니다."
        static let permissionAlertCancel = "취소"
        static let permissionAlertGoToSettings = "설정으로 이동"
    }
    
    private enum Metric {
        static let cornerRadius: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let createAlbumIconSize: CGFloat = 16
        static let settingIconSize: CGFloat = 24
        static let photoEmptyViewTopPadding: CGFloat = ScreenSize.height / 9
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var permissionManager: DefaultPhotoLibraryPermissionManager
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var isNeedPermission: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    // TODO: 설정 화면으로 이동
                } label: {
                    Image("setting_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Metric.settingIconSize, height: Metric.settingIconSize)
                }
                .hidden()   // FIXME: 추후에 사용
            }
            .frame(height: 52)
            .padding(.horizontal, Metric.horizontalPadding)
            
            if isNeedPermission {
                PermissionEmptyView()
            } else {
                HStack {
                    Text(Strings.topGreeting)
                        .chacFont(.headline_01)
                        .foregroundStyle(ColorPalette.text_01)
                    Spacer()
                }
                .padding(.horizontal, Metric.horizontalPadding)
                
                allPhotoButton {
                    // TODO: 모든사진 화면이동
                }
                
                HStack {
                    Image("create_album_icon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Metric.createAlbumIconSize, height: Metric.createAlbumIconSize)
                        .foregroundStyle(ColorPalette.text_02)
                    Text(Strings.createAlbum)
                        .chacFont(.sub_title_02)
                        .foregroundStyle(ColorPalette.text_02)
                    if photoLibraryStore.isLoading {
                        ProcessingView()
                    } else {
                        Text("\(photoLibraryStore.clusters.count)")
                            .chacFont(.number)
                            .foregroundStyle(ColorPalette.sub_01)
                    }
                    Spacer()
                }
                .padding(.top, 28)
                .padding(.horizontal, Metric.horizontalPadding)
                
                if photoLibraryStore.clusters.isEmpty {
                    LoadingView()
                } else {
                    content
                }
            }
        }
        .background(ColorPalette.background)
        .preferredColorScheme(.dark)
        .onChange(of: scenePhase, { _, newValue in
            switch newValue {
            case .active: handlePermissionStatus(permissionManager.permissionStatus)
            default:      break
            }
        })
        .onChange(of: permissionManager.permissionStatus) { _, newValue in
            handlePermissionStatus(newValue)
        }
    }
    
    private var content: some View {
        Group {
            if photoLibraryStore.clusters.isEmpty {
                PhotoEmptyView()
                    .padding(.top, Metric.photoEmptyViewTopPadding)
            } else {
                ScrollView {
                    VStack {
                        ForEach(Array(photoLibraryStore.clusters.enumerated()), id: \.element.id) { index, cluster in
							ClusterCell(
                            	viewModel: cluster.toViewModel(),
								backgroundColor: generateColor(at: index),
                            	onOrganizeTap: { coordinator.push(.photoSelect(index: index)) },
                            	onSaveTap: { savePhotos(cluster) }
                        	)
                        }
                    }
                    .padding(.horizontal, Metric.horizontalPadding)
                }
                .padding(.top, 15)
            }
        }
    }
    
    @ViewBuilder
    private func allPhotoButton(_ tapHandler: @escaping () -> Void) -> some View {
        Button {
            tapHandler()
        } label: {
            HStack(spacing: 0) {
                Text(Strings.allPhotos)
                    .chacFont(.content_title)
                    .foregroundStyle(ColorPalette.text_03)
                Spacer()
                Text("\(photoLibraryStore.photos.count)")
                    .chacFont(.number)
                    .foregroundStyle(ColorPalette.text_03)
                    .padding(.trailing, 6)
                Image("chevron_right_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 9, height: 19)
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, 20)
            .background(ColorPalette.white_5)
            .cornerRadius(Metric.cornerRadius)
            .padding(.top, 20)
            .padding(.horizontal, Metric.horizontalPadding)
        }
    }
    
    private func handlePermissionStatus(_ status: PHAuthorizationStatus) {
        if status == .notDetermined {
            permissionManager.requestPhotoLibraryPermission()
            return
        }
        
        if !permissionManager.hasPermission {
            isNeedPermission = true
            return
        }
        
        if permissionManager.hasPermission {
            photoLibraryStore.refreshIfAuthorized(status: status)
        }
    }
    
    private func generateColor(at index: Int) -> Color {
        let colorCycle = [
            ColorPalette.primary,
            ColorPalette.point_01,
            ColorPalette.point_02
        ]
        return colorCycle[index % colorCycle.count]
	}

    private func savePhotos(_ cluster: PhotoCluster) {
        Task {
            try? await photoLibraryStore.saveToAlbum(
                assets: cluster.phAssets,
                albumName: cluster.title
            )
        }
    }
}

#Preview {
    NavigationStack{
        MainView()
            .environmentObject(NavigationCoordinator())
            .environmentObject(DefaultPhotoLibraryPermissionManager())
            .environmentObject(PhotoLibraryStore())
    }
}
