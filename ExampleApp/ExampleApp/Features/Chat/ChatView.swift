//
//  ChatView.swift
//  ExampleApp
//
//  Created by Michael Maier on 04.10.22.
//

import SwiftUI
import EyesonSdk

struct ChatView: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    @State private var sendMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<coordinator.chatMessages.count, id: \.self) { index in
                        let message = coordinator.chatMessages[index]
                        let isGrouped = index > 0 && coordinator.chatMessages[index-1].user.id == message.user.id
                        ChatBubble(message: message,
                                   isGrouped: isGrouped)
                        .padding(.top, isGrouped ? 0 : 8)
                    }
                }
                .padding(16)
            }
            
            Divider()
            
            HStack {
                TextField("Write a message", text: $sendMessage)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    guard sendMessage != "" else { return }
                    coordinator.send(chat: sendMessage)
                    sendMessage = ""
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color.black)
                        .frame(width: 24, height: 24)
                })
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        }
    }
    
    struct ChatBubble: View {
        
        var message: ChatMessage
        var isGrouped: Bool
        
        var body: some View {
            HStack(spacing: 10) {
                
                ChatAvatar(user: message.isMe || isGrouped ? nil : message.user)
                
                VStack(spacing: 8) {
                    if !isGrouped {
                        HStack {
                            if message.isMe {
                                Spacer()
                                Time(timestamp: message.timestamp)
                            }
                            
                            Text(message.user.name)
                                .foregroundColor(.black)
                                .font(.system(size: 12, weight: .semibold))
                                .textCase(.uppercase)
                                .multilineTextAlignment(message.isMe ? .trailing : .leading)
                            
                            if !message.isMe {
                                Time(timestamp: message.timestamp)
                                Spacer()
                            }
                        }
                    }
                    
                    HStack {
                        if message.isMe {
                            Spacer()
                        }
                        
                        Text(message.message)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(message.isMe ? Color.gray : Color.black)
                            .cornerRadius(20, corners: [(message.isMe ? .topLeft : .topRight), .bottomLeft, .bottomRight])
                        
                        if !message.isMe {
                            Spacer()
                        }
                    }
                }
            }
        }
        
        struct Time: View {
            
            var timestamp: Date
            
            var body: some View {
                Text(timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .opacity(0.5)
            }
        }
        
        struct ChatAvatar: View {
            var user: Eyeson.User?
            var body: some View {
                VStack {
                    AsyncImage(url: user?.avatar) { result in
                        switch result {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            Color.clear
                        }
                    }
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                        .clipped()
                    Spacer()
                }
            }
        }
    }
}
