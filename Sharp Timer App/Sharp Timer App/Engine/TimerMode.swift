//
//  TimerMode.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation

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
            return "💼"
        case .restEyes:
            return "👁️"
        case .longRest:
            return "🌟"
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
