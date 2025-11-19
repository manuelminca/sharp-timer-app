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
    private var quitInitiatedFromUI = false
    
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
        
        // If quit was already initiated from the UI (quit button),
        // the confirmation dialog was already shown and handled
        if quitInitiatedFromUI {
            quitInitiatedFromUI = false // Reset flag
            return .terminateNow // Allow immediate termination
        }
        
        // Check if timer is running
        if appState.session.state == .running || appState.session.state == .paused {
            // Show quit confirmation dialog
            appState.showQuitConfirmation { shouldQuit in
                // This will be called after the dialog is handled
                if shouldQuit {
                    // Mark as initiated from UI to prevent loop when we reply true
                    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                        appDelegate.setQuitInitiatedFromUI()
                    }
                    NSApplication.shared.reply(toApplicationShouldTerminate: true)
                } else {
                    NSApplication.shared.reply(toApplicationShouldTerminate: false)
                }
            }
            return .terminateCancel // Cancel termination until dialog is handled
        } else {
            return .terminateNow // No timer running, allow immediate termination
        }
    }
    
    func setQuitInitiatedFromUI() {
        quitInitiatedFromUI = true
    }
    
    func resetQuitInitiatedFromUI() {
        quitInitiatedFromUI = false
    }
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
}
