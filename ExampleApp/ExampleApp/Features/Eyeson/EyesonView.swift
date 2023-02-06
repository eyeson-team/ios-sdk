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
            if let remoteVideoView = coordinator.remoteVideoView,
               !coordinator.startAudioOnly {
                EyesonViewRepresentable(uiView: remoteVideoView)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            } else {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "person.fill")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        
                        Text("\(coordinator.audioParticipants)")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .padding(.bottom, 12)
                    
                    Text("Audio-only mode")
                        .font(.system(size: 15))
                    
                    Text("No video stream is sent or received to save bandwidth in poor connection environments")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(0.5)
                }
                .foregroundColor(Color.white)
            }
            
            VStack(spacing: 0) {
                Spacer()
               
                HStack {
                    Spacer()
                    if let localVideoView = coordinator.localVideoView,
                       coordinator.showsLocalVideoView,
                       !coordinator.isScreencasting {
                        EyesonViewRepresentable(uiView: localVideoView)
                            .frame(width: 140,
                                   height: 210)
                            .padding(.trailing, 16)
                    }
                }
                
                if !coordinator.orientation.isLandscape {
                    EyesonButtons()
                        .opacity(coordinator.controlsHidden ? 0 : 1)
                }
            }
            
            if coordinator.orientation.isLandscape {
                EyesonButtons()
                    .opacity(coordinator.controlsHidden ? 0 : 1)
            }
        }
        .onTapGesture {
            coordinator.controlsHidden.toggle()
        }
        .animation(.easeInOut, value: coordinator.controlsHidden)
        .sheet(isPresented: $coordinator.showsChat) {
            NavigationView(title: "Chat", rightItem: Button("", action: {
                coordinator.showsChat.toggle()
            }).buttonStyle(SdkNavigationButtonStyle(icon: Image(systemName: "xmark")))) {
                ChatView()
            }
        }
    }
}

struct EyesonViewRepresentable: UIViewRepresentable {
    var uiView: UIView
    func makeUIView(context: Context) -> UIView { uiView }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
