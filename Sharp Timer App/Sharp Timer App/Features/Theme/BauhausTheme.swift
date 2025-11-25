import SwiftUI

public struct BauhausTheme {
    // Colors
    static let primaryRed = Color(red: 227/255, green: 28/255, blue: 35/255)
    static let primaryBlue = Color(red: 31/255, green: 70/255, blue: 144/255)
    static let primaryYellow = Color(red: 1.0, green: 211/255, blue: 0.0)
    static let background = Color(red: 240/255, green: 240/255, blue: 240/255)
    static let text = Color(red: 26/255, green: 26/255, blue: 26/255)
    static let surface = Color.white

    // Fonts
    static let headerFont = Font.system(size: 32, weight: .bold, design: .monospaced)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let buttonFont = Font.system(size: 14, weight: .semibold)
}