//
//  EyesonView.swift
//  ExampleApp
//
//  Created by Michael Maier on 15.12.21.
//

import SwiftUI

struct EyesonView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if let remoteVideoView = coordinator.remoteVideoView {
                EyesonVideoViewRepresentable(videoView: remoteVideoView)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
               
                HStack {
                    Spacer()
                    if let localVideoView = coordinator.localVideoView,
                       coordinator.showsLocalVideoView {
                        EyesonVideoViewRepresentable(videoView: localVideoView)
                            .frame(width: 140,
                                   height: 210)
                    }
                }
            }
            
            VStack {
                Spacer()
                                
                LogView(messages: coordinator.messages)
                    .frame(maxWidth: .infinity,
                           maxHeight: 140)
                
                HStack(spacing: 32) {
                    MicButton(isMuted: $coordinator.audioMuted)
                        .onChange(of: coordinator.audioMuted, perform: { mute in
                            coordinator.mute(.audio, coordinator.audioMuted)
                        })
                    
                    CamButton(isMuted: $coordinator.videoMuted)
                        .onChange(of: coordinator.videoMuted, perform: { mute in
                            coordinator.mute(.video, coordinator.videoMuted)
                        })
                    
                    ToggleCamButton(onTap: coordinator.toggleCam)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.2)
                        .ignoresSafeArea()

                )
            }
        }
        .overlay(CloseButton(onClose: coordinator.dismiss))
    }
    
    struct EyesonVideoViewRepresentable: UIViewRepresentable {
        var videoView: UIView
        func makeUIView(context: Context) -> UIView { videoView }
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}

struct Previews_EyesonView_Previews: PreviewProvider {
    static var previews: some View {
        EyesonView()
            .environmentObject(EyesonCoordinator())
    }
}
