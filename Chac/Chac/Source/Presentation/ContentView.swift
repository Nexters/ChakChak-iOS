//
//  ContentView.swift
//  ChakChak
//
//  Created by 이원빈 on 1/8/26.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    @StateObject private var permissionManger = DefaultPhotoLibraryPermissionManager()
    @StateObject private var photoLibraryStore = PhotoLibraryStore()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environmentObject(coordinator)
        .environmentObject(permissionManger)
        .environmentObject(photoLibraryStore)
    }
    
    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .main:
            MainView()
        case .photoSelect(let isTotal, let index):
            if isTotal {
                PhotoSelectView(cluster: PhotoCluster(id: UUID(), title: "모든 사진", phAssets: photoLibraryStore.photos))
            } else if let index = index {
                if index < photoLibraryStore.clusters.count {
                    PhotoSelectView(cluster: photoLibraryStore.clusters[index])
                } else {
                    Text("클러스터를 찾을 수 없습니다.")
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PhotoLibraryStore())
}
