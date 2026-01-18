//
//  ContentView.swift
//  ChakChak
//
//  Created by 이원빈 on 1/8/26.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MainView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .next:
                        NextView()
                    }
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
