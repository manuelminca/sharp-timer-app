//
//  TimerDisplayView.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI

struct TimerDisplayView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedMode: TimerMode = .work
    @State private var showingSettings = false
    @State private var quitButtonText = "Quit"
    @State private var settingsPopoverAttachment: NSWindow?
    @State private var quitWindowController: QuitWindowController?
    @State private var pulseScale: Double = 1.0
    @State private var pulseOpacity: Double = 0.3

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with decorative Bauhaus elements
                BauhausTheme.background
                    .ignoresSafeArea()
                
                // Decorative geometric elements
                decorativeBackgroundElements
                
                // Main content card
                VStack(spacing: 0) {
                    // Mode Selector
                    modeSelectorSection
                    
                    Spacer(minLength: 0)
                    
                    // Timer Display
                    timerDisplaySection
                    
                    Spacer(minLength: 0)
                    
                    // Control Buttons
                    controlButtonsSection
                    
                    Spacer(minLength: 0)
                    
                    // Action Buttons
                    actionButtonsSection
                }
                .padding(12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(BauhausTheme.surface)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(8)
            }
        }
        .frame(width: 300, height: 420) // Compact standard menu bar size
        .onAppear {
            selectedMode = appState.session.mode
            quitButtonText = "Quit"
            startPulseAnimation()
        }
        .popover(isPresented: $showingSettings, arrowEdge: .bottom) {
            DurationSettingsView()
                .environment(appState)
        }
    }
    
    // MARK: - Decorative Background Elements
    private var decorativeBackgroundElements: some View {
        ZStack {
            // Top left circle
            Circle()
                .fill(BauhausTheme.primaryRed.opacity(0.15))
                .frame(width: 48, height: 48)
                .position(x: 32, y: 32)
            
            // Bottom right square
            Rectangle()
                .fill(BauhausTheme.primaryYellow.opacity(0.15))
                .frame(width: 64, height: 64)
                .rotationEffect(.degrees(45))
                .position(x: -32, y: -32)
            
            // Right middle circle
            Circle()
                .fill(BauhausTheme.primaryBlue.opacity(0.15))
                .frame(width: 36, height: 36)
                .position(x: -48, y: 0)
        }
    }

    // MARK: - Mode Selector Section
    private var modeSelectorSection: some View {
        HStack(spacing: 4) {
            ForEach(TimerMode.allCases, id: \.self) { mode in
                Button(action: { switchToMode(mode) }) {
                    VStack(spacing: 6) {
                        // Icon
                        Image(systemName: mode.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(selectedMode == mode ? iconColor(for: mode) : BauhausTheme.text)
                        
                        // Label
                        Text(mode.displayName)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(selectedMode == mode ? iconColor(for: mode) : BauhausTheme.text)
                            .textCase(.uppercase)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .frame(height: 12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(selectedMode == mode ? mode.color : BauhausTheme.background)
                    )
                    .overlay(
                        // Bottom accent bar
                        Rectangle()
                            .fill(mode.color)
                            .frame(height: 3)
                            .opacity(selectedMode == mode ? 1.0 : 0.3)
                            .frame(maxHeight: .infinity, alignment: .bottom),
                        alignment: .bottom
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(selectedMode == mode ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: selectedMode)
            }
        }
        .frame(height: 60)
    }
    
    private func iconColor(for mode: TimerMode) -> Color {
        return mode == .longRest ? BauhausTheme.text : .white
    }

    // MARK: - Timer Display Section
    private var timerDisplaySection: some View {
        VStack(spacing: 4) {
            // Icon with geometric container
            ZStack {
                // Background geometric shape
                Circle()
                    .fill(modeColor.opacity(0.05))
                    .frame(width: 96, height: 96)
                
                // Icon container
                Circle()
                    .fill(modeColor)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: appState.session.mode.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(appState.session.mode == .longRest ? BauhausTheme.text : .white)
                    )
                
                // Animated pulse ring when running
                if appState.session.state == .running {
                    Circle()
                        .stroke(modeColor.opacity(0.3), lineWidth: 2)
                        .frame(width: 48, height: 48)
                        .scaleEffect(pulseScale)
                        .opacity(pulseOpacity)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: pulseScale
                        )
                }
            }
            
            // Timer display with geometric accents
            ZStack {
                // Side geometric accents
                HStack {
                    Rectangle()
                        .fill(modeColor.opacity(0.2))
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(45))
                    
                    Spacer()
                    
                    // Diamond shape using rotated square
                    Rectangle()
                        .fill(modeColor.opacity(0.2))
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(45))
                }
                
                // Main timer text
                VStack(spacing: 2) {
                    Text(formatTime(appState.session.remainingSeconds))
                        .font(.system(size: 56, weight: .bold, design: .monospaced))
                        .foregroundColor(BauhausTheme.text)
                        .contentTransition(.numericText())
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(height: 56)
                    
                    // Accent line
                    Rectangle()
                        .fill(modeColor)
                        .frame(height: 4)
                        .frame(maxWidth: 140)
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Control Buttons Section
    private var controlButtonsSection: some View {
        HStack(spacing: 16) {
            // Reset button - square
            Button(action: { appState.resetTimer() }) {
                Rectangle()
                    .fill(BauhausTheme.text)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Start/Pause button - large circle
            Button(action: {
                if appState.session.state == .running {
                    appState.pauseTimer()
                } else {
                    appState.startTimer(for: appState.session.mode)
                }
            }) {
                Circle()
                    .fill(appState.session.state == .running ? BauhausTheme.primaryYellow : BauhausTheme.primaryRed)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: appState.session.state == .running ? "pause.fill" : "play.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(appState.session.state == .running ? BauhausTheme.text : .white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(1.05)
            
            // Status indicator - circle with animated segments
            Circle()
                .fill(BauhausTheme.primaryBlue)
                .frame(width: 40, height: 40)
                .overlay(
                    // Animated segments
                    ForEach(0..<3, id: \.self) { index in
                        Rectangle()
                            .fill(.white)
                            .frame(width: 4, height: 12)
                            .cornerRadius(2)
                            .rotationEffect(.degrees(Double(index) * 120))
                            .offset(y: appState.session.state == .running ? -10 : -6)
                            .opacity(appState.session.state == .running ? 0.8 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .delay(Double(index) * 0.1)
                                    .repeatForever(autoreverses: true),
                                value: appState.session.state
                            )
                    }
                )
        }
        .padding(.vertical, 8)
    }

    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // Settings Button
            Button {
                showingSettings = true
            } label: {
                Text("Settings")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .tracking(1.2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(BauhausTheme.text)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Quit Button
            Button {
                quitApplication()
            } label: {
                Text("Quit")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(BauhausTheme.text)
                    .textCase(.uppercase)
                    .tracking(1.2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40) // Ensure full height
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(BauhausTheme.background) // Add background instead of clear
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(BauhausTheme.text, lineWidth: 2)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle()) // Make the entire button area tappable
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .frame(height: 40)
    }

    // MARK: - Computed Properties
    private var modeColor: Color {
        return appState.session.mode.color
    }
    
    // MARK: - Private Helpers
    private func switchToMode(_ mode: TimerMode) {
        selectedMode = mode
        appState.switchToMode(mode)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func quitApplication() {
        if appState.session.state == .running || appState.session.state == .paused {
            // Timer is active, show quit options window
            showQuitOptionsWindow()
        } else {
            // Timer is not active, quit directly
            NSApplication.shared.terminate(nil)
        }
    }
    
    private func showQuitOptionsWindow() {
        // Simple approach: always create a new window
        // The QuitWindowController.shared mechanism will prevent duplicates
        quitWindowController = QuitWindowController(appState: appState) {
            // Cancel action - the window controller handles hiding itself
        }
        quitWindowController?.show()
    }
    
    private func startPulseAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: false)
        ) {
            pulseScale = 1.3
            pulseOpacity = 0.0
        }
    }
}

#Preview {
    TimerDisplayView()
        .environment(AppState())
}
