//
//  LogView.swift
//  ExampleApp
//
//  Created by Michael Maier on 17.12.21.
//

import SwiftUI
import Eyeson

struct LogView: View {
    
    struct Message: Identifiable {
        var id = UUID()
        var primaryInfo: String
        var secondaryInfo: String
    }
    
    var messages = [Message]()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(messages.reversed()) { message in
                    HStack {
                        Text(message.primaryInfo)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(message.secondaryInfo)
                            .foregroundColor(.white)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                }
            }
            .padding(8)
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        let msg = LogView.Message(primaryInfo: "Michael Maier",
                                  secondaryInfo: "Just a message")
        LogView(messages: [msg])
            .background(Color.black)
    }
}
