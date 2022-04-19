//
//  ButtonViews.swift
//  ExampleApp
//
//  Created by Michael Maier on 17.12.21.
//

import SwiftUI

struct CloseButton: View {
    
    var onClose: (()->())
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .padding(16)
                }
            }
            Spacer()
        }
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
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
        }
    }
}

struct CamButton: View {
    
    @Binding var isMuted: Bool
    
    var body: some View {
        Button(action: {
            self.isMuted.toggle()
        }) {
            Image(systemName: isMuted ? "video.slash.fill" : "video.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
        }
    }
}

struct ToggleCamButton: View {
    
    var onTap: (()->())
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "arrow.triangle.2.circlepath.camera")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
        }
    }
}
