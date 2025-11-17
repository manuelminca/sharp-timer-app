//
//  MenuBarController.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI

// MARK: - Menu Bar Title Extension
extension Sharp_Timer_AppApp {
    nonisolated func menuBarTitle(for session: TimerSession) -> String {
        "\(session.mode.icon) \(formatTime(session.remainingSeconds))"
    }

    private nonisolated func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
