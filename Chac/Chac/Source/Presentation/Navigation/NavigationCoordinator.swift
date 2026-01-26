//
//  NavigationCoordinator.swift
//  Chac
//
//  Created by 이원빈 on 1/14/26.
//

import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
