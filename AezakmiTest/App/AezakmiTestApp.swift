//
//  AezakmiTestApp.swift
//  AezakmiTest
//
//  Created by Владимир Иванов on 13.09.2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure() // Инициализация Firebase
        return true
    }
}

    

@main
struct AezakmiTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SignInEmailView()
        }
    }
}


