//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Michael Maier on 13.12.21.
//

import SwiftUI

@main
struct ExampleAppApp: App {
    
    @ObservedObject private var coordinator = EyesonCoordinator()
        
    var body: some Scene {
        WindowGroup {
            NavigationView(rightItem: SettingsView(),
                           isOrientationResponsive: false) {
                SplashView()
                    .fullScreenCover(isPresented: $coordinator.isReady) {
                        MainView()
                    }
            }
            .environmentObject(coordinator)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                let orientation = UIDevice.current.orientation
                guard orientation != .unknown else { return }
                coordinator.orientation = orientation
            }
        }
    }
}
