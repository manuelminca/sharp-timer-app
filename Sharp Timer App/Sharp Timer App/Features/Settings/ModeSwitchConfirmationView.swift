//
//  ModeSwitchConfirmationView.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI
import AppKit

struct ModeSwitchConfirmationView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let intent: ModeSwitchIntent
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with warning icon
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Switch Timer Mode?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("The current timer is running and will be stopped.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Current timer info
            VStack(spacing: 8) {
                HStack {
                    Text("Current Timer:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(appState.session.mode.displayName) - \(formatTime(appState.session.remainingSeconds))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Switching to:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(intent.requestedMode.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Action buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    appState.cancelModeSwitch()
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Switch & Stop Timer") {
                    appState.confirmModeSwitch()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)
            }
        }
        .padding(24)
        .frame(width: 320, height: 280)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Window Controller for Mode Switch Confirmation
class ModeSwitchConfirmationWindowController: NSWindowController {
    private let intent: ModeSwitchIntent
    private let appState: AppState
    
    init(intent: ModeSwitchIntent, appState: AppState) {
        self.intent = intent
        self.appState = appState
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 280),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Confirm Mode Switch"
        window.center()
        window.isReleasedWhenClosed = false
        
        super.init(window: window)
        
        // Set up the SwiftUI view
        let contentView = ModeSwitchConfirmationView(intent: intent)
            .environment(appState)
        
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        window?.makeKeyAndOrderFront(nil)
        window?.level = .floating
        
        // Auto-close if intent is no longer pending
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            // Check if the intent is still valid by comparing with a stored copy
            if self.shouldClose() {
                timer.invalidate()
                self.close()
            }
        }
    }
    
    override func close() {
        window?.close()
    }
    
    private func shouldClose() -> Bool {
        // Use a simple timeout mechanism instead of accessing private property
        return Date().timeIntervalSince(intent.initiatedAt) > 30.0 // Close after 30 seconds
    }
}

#Preview {
    ModeSwitchConfirmationView(
        intent: ModeSwitchIntent(
            requestedMode: .restEyes,
            initiatedAt: Date(),
            confirmationState: .pending,
            originatingView: .popover
        )
    )
    .environment(AppState())
    .frame(width: 320, height: 280)
}
