//
//  LogView.swift
//  ExampleApp
//
//  Created by Michael Maier on 17.12.21.
//

import SwiftUI
import EyesonSdk

struct LogView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
        
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(coordinator.messages) { message in
                        HStack {
                            Text(message.primaryInfo)
                                .fontWeight(.bold)
                            
                            Text(message.secondaryInfo)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                    }
                }
                .padding(16)
            }
            
            Divider()
            
            HStack(spacing: 16) {
                Button("Clear", action: {
                    coordinator.messages = []
                })
                .buttonStyle(SdkButtonStyleSecondary())
                
                Button("Copy", action: {
                    UIPasteboard.general.string = coordinator.messages.map({ "\($0.primaryInfo): \($0.secondaryInfo)" }).joined(separator: "\n")
                })
                .buttonStyle(SdkButtonStylePrimary())
            }
            .padding(16)
        }
        .background(Color.white)
    }
}
