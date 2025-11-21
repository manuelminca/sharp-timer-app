import SwiftUI

public struct BauhausButtonStyle: ButtonStyle {
    let shape: BauhausShape

    enum BauhausShape {
        case circle
        case rectangle
        case square
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BauhausTheme.buttonFont)
            .foregroundColor(BauhausTheme.text)
            .padding()
            .background(BauhausTheme.primaryRed.opacity(configuration.isPressed ? 0.8 : 1.0))
            .clipShape(shapeView(for: shape))
    }

    private func shapeView(for shape: BauhausShape) -> some Shape {
        switch shape {
        case .circle:
            return AnyShape(Circle())
        case .rectangle:
            return AnyShape(RoundedRectangle(cornerRadius: 0))
        case .square:
            return AnyShape(RoundedRectangle(cornerRadius: 0))
        }
    }
}

// Helper to erase shape
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}