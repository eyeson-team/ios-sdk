//
//  SettingsView.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    @State private var showsSettings = false
    
    var body: some View {
        Button("", action: {
            showsSettings.toggle()
        })
        .buttonStyle(SdkNavigationButtonStyle(icon: Image(systemName: "gearshape.fill")))
        .fullScreenCover(isPresented: $showsSettings) {
            NavigationView(title: "Settings",
                           rightItem: EmptyView(),
                           onGoBack: {
                                showsSettings.toggle()
                           },
                           isOrientationResponsive: false) {
                ScrollView {
                    VStack(spacing: 0) {
                        MenuItem("Enable microphone on start") {
                            Toggle("", isOn: $coordinator.startMicEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                        MenuItem("Audio-only mode",
                                 label: "Enable for low data connection") {
                            Toggle("", isOn: $coordinator.startAudioOnly)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                        MenuItem("Enable video on start") {
                            Toggle("", isOn: $coordinator.startVideoEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                        MenuItem("Enable rear camera on start") {
                            Toggle("", isOn: $coordinator.startUseRearCam)
                                .toggleStyle(SwitchToggleStyle(tint: .black))
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
    }
}
