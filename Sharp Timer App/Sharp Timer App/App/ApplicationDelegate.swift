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
        return .terminateNow
    }
    
    
    func setAppState(_ appState: AppState) {
        self.appState = appState
    }
}
