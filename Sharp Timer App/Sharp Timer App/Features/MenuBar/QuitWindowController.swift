//
//  QuitWindowController.swift
//  Sharp Timer App
//
//  Created by QA Agent on 2025-11-20.
//

import SwiftUI
import AppKit

class QuitWindowController: NSWindowController, NSWindowDelegate {
    private var appState: AppState
    private var cancelAction: () -> Void
    static var shared: QuitWindowController?
    
    init(appState: AppState, cancelAction: @escaping () -> Void) {
        self.appState = appState
        self.cancelAction = cancelAction
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 280),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Quit Sharp Timer?"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.level = .floating
        window.backgroundColor = NSColor.windowBackgroundColor
        window.hasShadow = true
        
        super.init(window: window)
        
        // Create the SwiftUI view with the cancel callback after super.init
        setupContentView(in: window)
        
        // Set shared instance for access from SwiftUI
        QuitWindowController.shared = self
        
        // Center the window on screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowFrame = window.frame
            let x = screenFrame.midX - windowFrame.width / 2
            let y = screenFrame.midY - windowFrame.height / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
        window.delegate = self
    }
    
    private func setupContentView(in window: NSWindow) {
        // Create the SwiftUI view with the cancel callback and AppState
        let contentView = QuitOptionsView(onClose: { [weak self] in
            guard let self = self else { return }
            self.window?.performClose(nil)
        })
        .environment(appState)
        
        // Set up the hosting view with visual effect view for background
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .windowBackground
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 16
        visualEffectView.layer?.masksToBounds = true
        
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        visualEffectView.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor, constant: 0),
            hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor, constant: 0),
            hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor, constant: 0),
            hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor, constant: 0)
        ])
        
        // Create a container view to hold the visual effect view with proper clipping
        let containerView = NSView()
        containerView.wantsLayer = true
        containerView.layer?.masksToBounds = true
        containerView.addSubview(visualEffectView)
        
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        window.contentView = containerView
    }
    
    func show() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        // Make the window the key window to receive keyboard events
        window?.makeKey()
    }
    
    func hide() {
        // Force close immediately on main thread
        DispatchQueue.main.async { [weak self] in
            self?.window?.close()
        }
    }
    
    // MARK: - NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        // Clean up when window closes
        QuitWindowController.shared = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}