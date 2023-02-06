//
//  EyesonMenu.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import SwiftUI

struct EyesonMenuButton: View {
        
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    var body: some View {
        Button("", action: {
            coordinator.showsMenu.toggle()
        })
        .buttonStyle(SdkNavigationButtonStyle(icon: Image(systemName: coordinator.showsMenu ? "xmark" : "ellipsis")))
        .rotationEffect(.degrees(90))
    }
}

struct EyesonMenu: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
        
    var body: some View {
        HStack {
            if coordinator.orientation.isLandscape {
                Spacer()
            }
            
            VStack(spacing: 0) {
                Divider()
                
                VStack(spacing: 0) {
                    MenuItem("Full screen presentation") {
                        Toggle("", isOn: $coordinator.isPresenter)
                            .toggleStyle(SwitchToggleStyle(tint: .black))
                    }
                    
                    MenuItem("Mute all participants") {
                        Button("Mute", action: {
                            coordinator.muteAll()
                        })
                        .font(.system(size: 15, weight: .semibold))
                        .textCase(.uppercase)
                        .foregroundColor(.black)
                    }
                    
                    MenuItem("Show event log") {
                        Button("Show", action: {
                            coordinator.showsEventLog.toggle()
                        })
                        .font(.system(size: 15, weight: .semibold))
                        .textCase(.uppercase)
                        .foregroundColor(.black)
                    }
                }
                .cornerRadius(coordinator.orientation.isLandscape ? 16 : 0)
                .clipped()
                
                Spacer()
            }
            .padding(.top, coordinator.orientation.isLandscape ? 56 : 0)
            .frame(maxWidth: coordinator.orientation.isLandscape ? 420 : .infinity)
        }
        .background(Color.black.opacity(0.5))
    }
}
