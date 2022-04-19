//
//  SplashView.swift
//  ExampleApp
//
//  Created by Michael Maier on 13.12.21.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    @State private var accessKey: String = ""
    @State private var guestToken: String = ""
    @State private var name: String = ""
    
    private let qrScanner = ScanView()
    
    private func didScan(_ value: String) {
        guard !coordinator.isLoading,
              let url = URLComponents(string: value),
              let guestToken = url.queryItems?.first(where: { $0.name == "guest" })?.value else { return }
        qrScanner.stop()
        coordinator.load(guestToken: guestToken, name: "SDK User")
    }
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                TextField("Access Token", text: $accessKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Join", action: {
                    coordinator.load(accessKey: accessKey)
                })
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(coordinator.isLoading)
            }
            
            Divider()
            
            VStack {
                TextField("Guest Token", text: $guestToken)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Join", action: {
                    coordinator.load(guestToken: guestToken,
                                           name: name)
                })
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(coordinator.isLoading)
            }
            
            Divider()
            
            Text(coordinator.isLoading ? "Loading..." : "Scan guest QR code")
            
            if !coordinator.isReady
                && !coordinator.isLoading {
                qrScanner
                    .frame(width: 240, height: 240)
                    .clipped()
                    .onAppear {
                        qrScanner.start(completion: didScan)
                    }
            }
        }
        .padding(64)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(EyesonCoordinator())
    }
}
