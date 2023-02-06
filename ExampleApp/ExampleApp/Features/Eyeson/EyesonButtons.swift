//
//  EyesonButtons.swift
//  ExampleApp
//
//  Created by Michael Maier on 17.12.21.
//

import SwiftUI

struct EyesonButtons: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
        
    var body: some View {
        if coordinator.orientation.isLandscape {
            LandscapeButtons()
        } else {
            PortraitButtons()
        }
    }
    
    struct PortraitButtons: View {
        
        @EnvironmentObject var coordinator: EyesonCoordinator
                
        var body: some View {
            HStack {
                ToggleCamButton(onTap: coordinator.toggleCam)
                    .disabled(coordinator.startAudioOnly)
                    .frame(maxWidth: .infinity)
                                
                CamButton(isMuted: $coordinator.videoMuted)
                    .disabled(coordinator.startAudioOnly)
                    .frame(maxWidth: .infinity)
                                
                MicButton(isMuted: $coordinator.audioMuted)
                    .frame(maxWidth: .infinity)
                                
                SpeakerButton(isMuted: $coordinator.remoteAudioMuted)
                    .frame(maxWidth: .infinity)
                                
                ChatButton(isShown: $coordinator.showsChat)
                    .frame(maxWidth: .infinity)
                                
                ScreencastButton(tintColor: Color.black,
                                 isScreencasting: coordinator.isScreencasting,
                                 action: {})
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                Color.white
                    .cornerRadius(16)
            )
            .padding(.horizontal, 16)
        }
    }
    
    struct LandscapeButtons: View {
        
        @EnvironmentObject var coordinator: EyesonCoordinator
        
        var body: some View {
            HStack {
                VStack {
                    ToggleCamButton(onTap: coordinator.toggleCam)
                        .disabled(coordinator.startAudioOnly)
                        .frame(maxHeight: .infinity)
                                        
                    CamButton(isMuted: $coordinator.videoMuted)
                        .disabled(coordinator.startAudioOnly)
                        .frame(maxHeight: .infinity)
                                        
                    MicButton(isMuted: $coordinator.audioMuted)
                        .frame(maxHeight: .infinity)
                                        
                    SpeakerButton(isMuted: $coordinator.remoteAudioMuted)
                        .frame(maxHeight: .infinity)
                                        
                    ChatButton(isShown: $coordinator.showsChat)
                        .frame(maxHeight: .infinity)
                                        
                    ScreencastButton(tintColor: Color.white,
                                     isScreencasting: coordinator.isScreencasting,
                                     action: {})
                    .frame(maxHeight: .infinity)
                }
                .padding(.top, 56)
                
                Spacer()
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    struct MicButton: View {
        
        @Binding var isMuted: Bool
        
        var body: some View {
            Button(action: {
                self.isMuted.toggle()
            }) {
                Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
    }

    struct CamButton: View {
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        @Binding var isMuted: Bool
        
        var body: some View {
            Button(action: {
                self.isMuted.toggle()
            }) {
                Image(systemName: isMuted ? "video.slash.fill" : "video.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .opacity(isEnabled ? 1.0 : 0.25)
            }
        }
    }

    struct ToggleCamButton: View {
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var onTap: (()->())
        
        var body: some View {
            Button(action: onTap) {
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .opacity(isEnabled ? 1.0 : 0.25)
            }
        }
    }

    struct SpeakerButton: View {
        
        @Binding var isMuted: Bool
        
        var body: some View {
            Button(action: {
                self.isMuted.toggle()
            }) {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
    }

    struct ChatButton: View {
        
        @Binding var isShown: Bool
        
        var body: some View {
            Button(action: {
                self.isShown.toggle()
            }) {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
    }

}
