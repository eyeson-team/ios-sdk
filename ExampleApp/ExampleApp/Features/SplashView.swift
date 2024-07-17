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
    @State private var permalinkUserToken: String = ""
    @State private var name: String = UIDevice.current.name
    @State private var showsScanner = false
    
    private let qrScanner = ScanView()
    
    private func didScan(_ value: String) {
        guestToken = tokenFrom(value)
        showsScanner = false
    }
    
    private func joinMeeting() {
        if accessKey != "" {
            coordinator.load(accessKey: accessKey)
            return
        }
        
        if permalinkUserToken != "" {
            coordinator.start(permalink: permalinkUserToken)
            return
        }
        
        let guestToken = tokenFrom(guestToken)
        coordinator.load(guestToken: guestToken, name: name)
    }
    
    private func tokenFrom(_ value: String) -> String {
        guard let url = URLComponents(string: value),
              let guestToken = url.queryItems?.first(where: { $0.name == "guest" })?.value else { return value }
        return guestToken
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ScrollView {
                VStack(spacing: 8) {
                    Image("EyesonLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 27)
                        .padding(.bottom, 8)
                    
                    Text("iOS SDK")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 32)
                    
                    Text("Enter the access key of a meeting")
                        .font(.system(size: 15))
                        .padding(.bottom, 8)
                    
                    TextField("", text: $accessKey)
                        .textFieldStyle(SdkTextFieldStyle(label: "Access Key"))
                    
                    Text("... or join via guest token or link.")
                        .font(.system(size: 15))
                        .padding(.vertical, 8)
                    
                    TextField("", text: $name)
                        .textFieldStyle(SdkTextFieldStyle(label: "Guest Name"))
                    
                    TextField("", text: $guestToken)
                        .textFieldStyle(SdkTextFieldStyle(label: "Guest Token/Link"))
                        .padding(.bottom, 8)
                    
                    Button("Scan guest QR code", action: {
                        showsScanner.toggle()
                    })
                        .buttonStyle(SdkButtonStyleSecondary())
                        .padding(.bottom, 16)
                    
                    Text("... or join via permalink user token.")
                        .font(.system(size: 15))
                        .padding(.vertical, 8)
                    
                    TextField("", text: $permalinkUserToken)
                        .textFieldStyle(SdkTextFieldStyle(label: "Permalink User Token"))
                }
            }
            
            Divider()
                .padding(.bottom, 8)
            
            Button("Connect", action: joinMeeting)
                .buttonStyle(SdkButtonStylePrimary())
                .disabled(coordinator.isLoading)
                .sheet(isPresented: $showsScanner, content: {
                    if !coordinator.isReady
                        && !coordinator.isLoading {
                        qrScanner
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .onAppear {
                                qrScanner.start(completion: didScan)
                            }
                            .onDisappear {
                                qrScanner.stop()
                            }
                    }
                })
        }
        .padding(16)
    }
}
