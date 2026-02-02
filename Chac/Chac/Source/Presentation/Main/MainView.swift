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
        static let allPhotos = "모든 사진"
        static let createAlbum = "앨범 생성"
        static let permissionAlertTitle = "앨범 접근 권한"
        static let permissionAlertMessage = "앨범에 접근하려면 사진 접근 권한이 필요합니다."
        static let permissionAlertCancel = "취소"
        static let permissionAlertGoToSettings = "설정으로 이동"
    }
    
    private enum Metric {
        static let cornerRadius: CGFloat = 4
        static let horizontalPadding: CGFloat = 20
        static let createAlbumIconSize: CGFloat = 16
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var permissionManager: DefaultPhotoLibraryPermissionManager
    @EnvironmentObject private var photoLibraryStore: PhotoLibraryStore
    @State private var isPresentNeedPermissionAlert: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("로고/서비스 네임")
                Spacer()
                Button {
                    // TODO: 설정 화면으로 이동
                } label: {
                    Image("setting_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .frame(height: 52)
            .padding(.horizontal, Metric.horizontalPadding)

            HStack {
                Text(Strings.allPhotos)
                Spacer()
                Text("\(photoLibraryStore.photos.count)")
            }
            .padding(.horizontal, Metric.horizontalPadding)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(ColorPalette.gray)
            .cornerRadius(Metric.cornerRadius)
            .padding(.top, 12)
            .padding(.horizontal, Metric.horizontalPadding)
            
            HStack {
                Image("create_album_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Metric.createAlbumIconSize, height: Metric.createAlbumIconSize)
                Text(Strings.createAlbum)
                Spacer()
            }
            .padding(.top, 28)
            .padding(.horizontal, Metric.horizontalPadding)
            
            ScrollView {
                VStack {
                    ForEach(photoLibraryStore.clusters, id: \.id) { cluster in
                        ClusterCell(
                            viewModel: cluster.toViewModel(),
                            onOrganizeTap: { coordinator.push(.photoSelect(id: cluster.id)) },
                            onSaveTap: { savePhotos(cluster) }
                        )
                    }
                    
                    LoadingView()
                }
                .padding(.horizontal, Metric.horizontalPadding)
            }
            .padding(.top, 15)
        }
        .onChange(of: scenePhase, { _, newValue in
            switch newValue {
            case .active: handlePermissionStatus(permissionManager.permissionStatus)
            default:      break
            }
        })
        .onChange(of: permissionManager.permissionStatus) { _, newValue in
            handlePermissionStatus(newValue)
        }
        .alert(Strings.permissionAlertTitle, isPresented: $isPresentNeedPermissionAlert) {
            Button(Strings.permissionAlertCancel, role: .cancel) {}
            Button(Strings.permissionAlertGoToSettings) {
                permissionManager.openSettings()
            }
        } message: {
            Text(Strings.permissionAlertMessage)
        }
    }
    
    private func handlePermissionStatus(_ status: PHAuthorizationStatus) {
        if status == .denied {
            isPresentNeedPermissionAlert = true
            return
        }
        
        if status == .notDetermined {
            permissionManager.requestPhotoLibraryPermission()
            return
        }
        
        if permissionManager.hasPermission {
            photoLibraryStore.refreshIfAuthorized(status: status)
        }
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
