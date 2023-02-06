//
//  ScreencastPickerView.swift
//  ExampleApp
//
//  Created by Michael Maier on 01.12.22.
//

import UIKit
import SwiftUI
import ReplayKit

struct ScreencastButton: View {
    
    private let tintColor: Color
    private let isScreencasting: Bool
    private let action: ()->()
    private let coordinator: ScreencastCoordinator
    
    init(tintColor: Color, isScreencasting: Bool, action: @escaping ()->()) {
        self.tintColor = tintColor
        self.isScreencasting = isScreencasting
        self.action = action
        self.coordinator = ScreencastCoordinator(tintColor: UIColor(tintColor))
    }
    
    class ScreencastCoordinator {
        var button: UIButton?
        
        private let pickerView: RPSystemBroadcastPickerView
        private let tintColor: UIColor
        
        init(tintColor: UIColor) {
            self.tintColor = tintColor
            pickerView = RPSystemBroadcastPickerView()
            pickerView.preferredExtension = "com.eyeson.sdk-ExampleApp.BroadcastExtension"
            pickerView.backgroundColor = .clear
            pickerView.showsMicrophoneButton = false
        }
        
        func pickerView(isScreencasting: Bool) -> UIView {
            for subview in pickerView.subviews {
                if let button = subview as? UIButton {
                    button.imageView?.tintColor = isScreencasting ? .red : tintColor
                    button.frame = pickerView.bounds
                    button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.button = button
                }
            }
            return pickerView
        }
    }
    
    var body: some View {
        VStack {
            if isScreencasting {
                ScreencastPickerView(coordinator: coordinator,
                                     isScreencasting: true)
            } else {
                ScreencastPickerView(coordinator: coordinator,
                                     isScreencasting: false)
            }
        }
        .onTapGesture {
            coordinator.button?.sendActions(for: .touchUpInside)
            action()
        }
    }
    
    struct ScreencastPickerView: View {
        
        var coordinator: ScreencastCoordinator
        var isScreencasting: Bool
        
        var body: some View {
            EyesonViewRepresentable(uiView: coordinator.pickerView(isScreencasting: isScreencasting))
                .frame(width: 24, height: 24)
        }
    }
}
