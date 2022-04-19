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
    
    @State private var showsEyesonView = false
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(coordinator)
                .fullScreenCover(isPresented: $showsEyesonView) {
                                    EyesonView()
                                        .environmentObject(coordinator)
                                }
                                 .onChange(of: coordinator.isReady, perform: { ready in
                                     self.showsEyesonView = ready
                                 })
        }
    }
}
