//
//  TimerMode.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation
import SwiftUI

enum TimerMode: String, CaseIterable, Identifiable, Codable {
    case work
    case restEyes
    case longRest

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .work:
            return "Work"
        case .restEyes:
            return "Rest Your Eyes"
        case .longRest:
            return "Long Rest"
        }
    }

    var icon: String {
        switch self {
        case .work:
            return "briefcase.fill"
        case .restEyes:
            return "eye.fill"
        case .longRest:
            return "cup.and.saucer.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .work:
            return Color(red: 227/255, green: 28/255, blue: 35/255)
        case .restEyes:
            return Color(red: 31/255, green: 70/255, blue: 144/255)
        case .longRest:
            return Color(red: 1.0, green: 211/255, blue: 0.0)
        }
    }

    var defaultMinutes: Int {
        switch self {
        case .work:
            return 25
        case .restEyes:
            return 2
        case .longRest:
            return 15
        }
    }
}
