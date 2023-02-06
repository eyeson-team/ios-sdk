//
//  DesignUtils.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import SwiftUI

extension Color {
    public static let white: Color = Color("White")
    public static let black: Color = Color("Black")
    public static let gray: Color = Color("Gray")
}

struct SdkButtonStylePrimary: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .font(.system(size: 15, weight: .semibold))
            .textCase(.uppercase)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.black.opacity(isEnabled ? 1.0 : 0.5))
            .cornerRadius(6)
    }
}

struct SdkButtonStyleSecondary: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.black)
            .font(.system(size: 15, weight: .semibold))
            .textCase(.uppercase)
            .frame(maxWidth: .infinity)
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

struct SdkNavigationButtonStyle: ButtonStyle {
        
    var icon: Image
    
    func makeBody(configuration: Self.Configuration) -> some View {
        icon
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .padding(4)
            .frame(width: 24, height: 24)
            .contentShape(Rectangle())
    }
}

struct SdkTextFieldStyle: TextFieldStyle {
    
    var label: LocalizedStringKey
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(spacing: 4) {            
            Text(label)
                .foregroundColor(Color.black)
                .font(.system(size: 12, weight: .semibold))
                .textCase(.uppercase)
                .opacity(0.6)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            configuration
                .foregroundColor(.black)
                .font(.system(size: 16))
                .textCase(.uppercase)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
