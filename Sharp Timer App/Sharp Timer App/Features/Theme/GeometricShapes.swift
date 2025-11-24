//
//  GeometricShapes.swift
//  Sharp Timer App
//
//  Created by Bauhaus Design System
//

import SwiftUI

struct PentagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        // Pentagon vertices
        let vertices = [
            CGPoint(x: centerX, y: centerY - radius), // Top
            CGPoint(x: centerX + radius * 0.951, y: centerY - radius * 0.309), // Upper right
            CGPoint(x: centerX + radius * 0.588, y: centerY + radius * 0.809), // Lower right
            CGPoint(x: centerX - radius * 0.588, y: centerY + radius * 0.809), // Lower left
            CGPoint(x: centerX - radius * 0.951, y: centerY - radius * 0.309) // Upper left
        ]
        
        path.move(to: vertices[0])
        for vertex in vertices.dropFirst() {
            path.addLine(to: vertex)
        }
        path.closeSubpath()
        
        return path
    }
}

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        
        path.move(to: CGPoint(x: centerX, y: 0))
        path.addLine(to: CGPoint(x: width, y: centerY))
        path.addLine(to: CGPoint(x: centerX, y: height))
        path.addLine(to: CGPoint(x: 0, y: centerY))
        path.closeSubpath()
        
        return path
    }
}