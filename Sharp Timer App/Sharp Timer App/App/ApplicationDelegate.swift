//
//  AppDelegate.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var appState: AppState?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request notification permissions
        Task {
            if let appState = appState {
                await appState.requestNotificationPermission()
            }
        }
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let appState = appState else {
            return .terminateNow
        }
        
        // Check if timer is running
        if appState.session.state == .running || appState.session.state == .paused {
            // Show quit confirmation dialog
            appState.showQuitConfirmation {
                // This will be called after the dialog is handled
                NSApplication.shared.reply(toApplicationShouldTerminate: true)
            }
            return .terminateCancel // Cancel termination until dialog is handled
        } else {
            return .terminateNow // No timer running, allow immediate termination
        }
    }
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
}
