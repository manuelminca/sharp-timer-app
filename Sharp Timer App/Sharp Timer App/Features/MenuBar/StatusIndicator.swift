//
//  StatusIndicator.swift
//  Sharp Timer App
//
//  Created by Bauhaus Design System
//

import SwiftUI

struct StatusIndicator: View {
    let isRunning: Bool
    
    @State private var animationPhase: Double = 0
    
    var body: some View {
        Circle()
            .fill(BauhausTheme.primaryBlue)
            .frame(width: 80, height: 80)
            .overlay(
                // Animated segments
                ForEach(0..<3, id: \.self) { index in
                    Rectangle()
                        .fill(.white)
                        .frame(width: 8, height: 32)
                        .cornerRadius(4)
                        .rotationEffect(.degrees(Double(index) * 120))
                        .offset(y: isRunning ? -20 : -16)
                        .opacity(isRunning ? 0.8 : 0.3)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .delay(Double(index) * 0.1)
                                .repeatForever(autoreverses: true),
                            value: isRunning
                        )
                }
            )
    }
}