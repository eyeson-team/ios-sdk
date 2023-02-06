//
//  ChatMessage.swift
//  ExampleApp
//
//  Created by Michael Maier on 04.10.22.
//

import EyesonSdk

struct ChatMessage: Identifiable {
    var id: String
    var timestamp: Date
    var user: Eyeson.User
    var isMe: Bool
    var message: String
}
