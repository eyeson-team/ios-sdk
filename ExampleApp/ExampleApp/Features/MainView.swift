//
//  MainView.swift
//  ExampleApp
//
//  Created by Michael Maier on 21.12.22.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
        
    var body: some View {
        NavigationView(rightItem: EyesonMenuButton(),
                       onGoBack: coordinator.dismiss) {
            EyesonView()
                .overlay(
                    EyesonMenu()
                        .opacity(coordinator.showsMenu ? 1.0 : 0.0)
                )
                .onTapGesture {
                    coordinator.showsMenu = false
                }
        }
        .background(Color(.darkGray).ignoresSafeArea())
        .sheet(isPresented: $coordinator.showsEventLog) {
            NavigationView(title: "Event Log",
                           rightItem: Button("", action: {
                coordinator.showsEventLog.toggle()
            }).buttonStyle(SdkNavigationButtonStyle(icon: Image(systemName: "xmark")))) {
                LogView()
            }
        }
    }
    
}
