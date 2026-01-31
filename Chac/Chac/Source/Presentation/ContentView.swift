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
        case .photoSelect(let id):
            if let cluster = photoLibraryStore.clusters.first(where: { $0.id == id }) {
                PhotoSelectView(cluster: cluster)
            } else {
                Text("클러스터를 찾을 수 없습니다.")
            }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PhotoLibraryStore())
}
