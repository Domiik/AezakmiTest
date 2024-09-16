//
//  AuthCoordinator.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 14.09.2024.
//

import SwiftUI

enum AuthRoute: Hashable {
    case registration
}

final class AuthCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isShowingResetPassword = false
    
    func navigate(to route: AuthRoute) {
        path.append(route)
    }
    
    func showResetPassword() {
        isShowingResetPassword = true
    }
    
    func goBack() {
        path.removeLast()
    }
}
