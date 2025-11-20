//
//  Sharp_Timer_AppApp.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI
import UserNotifications

@main
struct Sharp_Timer_AppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            TimerDisplayView()
                .environment(appState)
                .onAppear {
                    // Set up the app state in the delegate
                    appDelegate.setAppState(appState)
                }
        } label: {
            if appState.session.state == .running || appState.session.state == .paused {
                Text(formatTime(appState.session.remainingSeconds))
            } else {
                Image(systemName: "timer")
            }
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - Menu Bar Title Extension
extension Sharp_Timer_AppApp {
    nonisolated func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
