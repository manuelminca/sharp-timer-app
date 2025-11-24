//
//  BauhausActionButtonStyle.swift
//  Sharp Timer App
//
//  Created by Bauhaus Design System
//

import SwiftUI

struct BauhausActionButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let hoverColor: Color
    let borderColor: Color?
    
    init(backgroundColor: Color, hoverColor: Color, borderColor: Color? = nil) {
        self.backgroundColor = backgroundColor
        self.hoverColor = hoverColor
        self.borderColor = borderColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(configuration.isPressed ? hoverColor : backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 2 : 0)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}