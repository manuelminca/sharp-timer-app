//
//  ControlButton.swift
//  Sharp Timer App
//
//  Created by Bauhaus Design System
//

import SwiftUI

struct ControlButton: View {
    let icon: String
    let color: Color
    let hoverColor: Color?
    let size: CGFloat
    let shape: ButtonShape
    let isPrimary: Bool
    let action: () -> Void
    
    enum ButtonShape {
        case circle
        case square
    }
    
    init(
        icon: String,
        color: Color,
        hoverColor: Color? = nil,
        size: CGFloat,
        shape: ButtonShape,
        isPrimary: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.hoverColor = hoverColor
        self.size = size
        self.shape = shape
        self.isPrimary = isPrimary
        self.action = action
    }
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background
                Group {
                    if shape == .circle {
                        Circle()
                            .fill(backgroundColor)
                            .frame(width: size, height: size)
                    } else {
                        Rectangle()
                            .fill(backgroundColor)
                            .frame(width: size, height: size)
                    }
                }
                
                // Rotating geometric accent for primary button
                if isPrimary {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.clear, accentColor, Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: size, height: size)
                        .opacity(0.2)
                        .rotationEffect(.degrees(isHovered ? 180 : 0))
                        .animation(.easeInOut(duration: 0.7), value: isHovered)
                }
                
                // Icon
                Image(systemName: icon)
                    .font(.system(size: size * 0.375, weight: .medium))
                    .foregroundColor(iconColor)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.05 : 1.0))
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onHover { hovering in
            isHovered = hovering
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
    
    private var backgroundColor: Color {
        if isPressed {
            return color.opacity(0.8)
        } else if isHovered {
            return hoverColor ?? color
        } else {
            return color
        }
    }
    
    private var iconColor: Color {
        if isPrimary {
            return color == BauhausTheme.primaryYellow ? BauhausTheme.text : .white
        } else {
            return .white
        }
    }
    
    private var accentColor: Color {
        return color == BauhausTheme.primaryYellow ? BauhausTheme.text : .white
    }
}