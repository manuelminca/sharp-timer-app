//
//  ModeButton.swift
//  Sharp Timer App
//
//  Created by Bauhaus Design System
//

import SwiftUI

struct ModeButton: View {
    let mode: TimerMode
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon
                Image(systemName: mode.icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(isSelected ? iconColor : BauhausTheme.text)
                
                // Label
                Text(mode.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? iconColor : BauhausTheme.text)
                    .textCase(.uppercase)
                    .tracking(1)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelected ? modeColor : BauhausTheme.background)
            )
            .overlay(
                // Geometric accent when selected
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(iconColor.opacity(0.2))
                            .frame(width: 64, height: 64)
                            .rotationEffect(.degrees(45))
                            .offset(x: 20, y: -20)
                    }
                }
            )
            .overlay(
                // Bottom accent bar
                Rectangle()
                    .fill(modeColor)
                    .frame(height: 4)
                    .opacity(isSelected ? 1.0 : 0.3)
                    .frame(maxHeight: .infinity, alignment: .bottom),
                alignment: .bottom
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
    
    private var modeColor: Color {
        switch mode {
        case .work:
            return BauhausTheme.primaryRed
        case .restEyes:
            return BauhausTheme.primaryBlue
        case .longRest:
            return BauhausTheme.primaryYellow
        }
    }
    
    private var iconColor: Color {
        return mode == .longRest ? BauhausTheme.text : .white
    }
}