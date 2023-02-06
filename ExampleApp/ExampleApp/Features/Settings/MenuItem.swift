//
//  MenuItem.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import SwiftUI

struct MenuItem<Content: View>: View {
    
    var title: LocalizedStringKey
    var label: LocalizedStringKey?
    var content: Content
    
    init(_ title: LocalizedStringKey, label: LocalizedStringKey? = nil, @ViewBuilder content: @escaping ()->Content) {
        self.title = title
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.black)
                    
                    if let label = label {
                        Text(label)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.gray)
                    }
                }
                                    
                content
                    .padding(.trailing, 16)
            }
            
            Divider()
        }
        .padding(.leading, 16)
        .padding(.top, 16)
        .background(Color.white)
    }
}
