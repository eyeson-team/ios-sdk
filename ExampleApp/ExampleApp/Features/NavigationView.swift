//
//  NavigationView.swift
//  ExampleApp
//
//  Created by Michael Maier on 03.10.22.
//

import SwiftUI

struct NavigationView<Content: View, NavigationButton: View>: View {
    
    @EnvironmentObject var coordinator: EyesonCoordinator
    
    var title: LocalizedStringKey?
    var rightItem: NavigationButton
    var onGoBack: (()->())?
    var isOrientationResponsive: Bool = true
    @ViewBuilder var content: Content
    
    @State private var paddingTop = 56.0
    
    private func updatePadding() {
        withAnimation {
            paddingTop = isOrientationResponsive && (coordinator.controlsHidden || coordinator.orientation.isLandscape) ? 0 : 56
        }
    }
            
    var body: some View {
        GeometryReader { geo in
            ZStack {
                content
                    .frame(maxHeight: .infinity)
                    .padding(.top, paddingTop)
                    .onAppear(perform: updatePadding)
                    .onChange(of: coordinator.controlsHidden, perform: { _ in
                        updatePadding()
                    })
                    .onChange(of: coordinator.orientation, perform: { _ in
                        updatePadding()
                    })
                
                VStack {
                    HStack {
                        if let onGoBack = onGoBack {
                            Button("", action: onGoBack)
                                .buttonStyle(SdkNavigationButtonStyle(icon: Image(systemName: "arrow.backward")))
                            Spacer()
                        }
                        
                        if let title = title {
                            Text(title)
                                .font(.system(size: 18, weight: .bold))
                                .textCase(.uppercase)
                        }
                        
                        Spacer()
                        
                        rightItem
                    }
                    .foregroundColor(coordinator.orientation.isLandscape && isOrientationResponsive ? Color.white : Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .padding(.top, geo.safeAreaInsets.top)
                    .background(coordinator.orientation.isLandscape && isOrientationResponsive ? Color.clear : Color.white)
                    .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .opacity(isOrientationResponsive && coordinator.controlsHidden ? 0 : 1)
                .animation(.easeInOut, value: coordinator.controlsHidden)
            }
        }
    }
}
