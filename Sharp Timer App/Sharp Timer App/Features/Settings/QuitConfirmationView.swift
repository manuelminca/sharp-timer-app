//
//  QuitConfirmationView.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI
import AppKit

struct QuitConfirmationView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    let intent: QuitIntent
    let onCompletion: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with warning icon
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Timer is active now")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Are you sure you want to quit the app?")
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
                    Text("Status:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(appState.session.state == .running ? "Running" : "Paused")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(appState.session.state == .running ? .green : .orange)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Action buttons
            VStack(spacing: 8) {
                Button("Stop timer and Quit") {
                    Task {
                        await appState.processQuitIntent(.stopAndQuit)
                        dismiss()
                        // Small delay to ensure UI updates complete before termination
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCompletion?()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)
                
                Button("Quit and leave timer running") {
                    Task {
                        await appState.processQuitIntent(.persistAndQuit)
                        dismiss()
                        // Small delay to ensure UI updates complete before termination
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCompletion?()
                        }
                    }
                }
                .keyboardShortcut("s", modifiers: .command)
                
                Button("Cancel") {
                    Task {
                        await appState.processQuitIntent(.cancel)
                    }
                    dismiss()
                    // Don't call onCompletion for cancel - just close the dialog
                }
                .keyboardShortcut(.escape)
            }
        }
        .padding(24)
        .frame(width: 360, height: 320)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Window Controller for Quit Confirmation
class QuitConfirmationWindowController: NSWindowController {
    private let intent: QuitIntent
    private let appState: AppState
    private var onCompletion: (() -> Void)?
    
    init(intent: QuitIntent, appState: AppState, onCompletion: @escaping () -> Void) {
        self.intent = intent
        self.appState = appState
        self.onCompletion = onCompletion
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 320),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Confirm Quit"
        window.center()
        window.isReleasedWhenClosed = false
        
        super.init(window: window)
        
        // Set up the SwiftUI view
        let contentView = QuitConfirmationView(intent: intent, onCompletion: onCompletion)
            .environment(appState)
        
        window.contentView = NSHostingView(rootView: contentView)
        
        // Handle window close
        window.delegate = self
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
            
            if self.shouldClose() {
                timer.invalidate()
                self.close()
            }
        }
    }
    
    override func close() {
        onCompletion?()
        super.close()
    }
    
    private func shouldClose() -> Bool {
        // Use a simple timeout mechanism instead of accessing private property
        return intent.handled
    }
}

// MARK: - Window Delegate
extension QuitConfirmationWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        onCompletion?()
    }
}

#Preview {
    QuitConfirmationView(
        intent: QuitIntent(
            action: .cancel,
            handled: false,
            snapshot: nil
        ),
        onCompletion: nil
    )
    .environment(AppState())
    .frame(width: 360, height: 320)
}
