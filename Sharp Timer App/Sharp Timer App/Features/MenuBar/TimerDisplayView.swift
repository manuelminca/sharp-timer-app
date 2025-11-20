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

    var body: some View {
        VStack(spacing: 16) {
            // Mode Picker
            modePickerSection

            // Timer Display
            timerDisplaySection

            // Control Buttons
            controlButtonsSection

            // Action Buttons (Settings and Quit)
            actionButtonsSection
        }
        .padding()
        .onAppear {
            selectedMode = appState.session.mode
            quitButtonText = "Quit"
        }
        .popover(isPresented: $showingSettings, arrowEdge: .bottom) {
            DurationSettingsView()
                .environment(appState)
        }
    }

    // MARK: - Mode Picker Section
    private var modePickerSection: some View {
        Picker("", selection: $selectedMode) {
            ForEach(TimerMode.allCases) { mode in
                Label(mode.displayName, systemImage: mode.icon)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedMode) { _, newMode in
            switchToMode(newMode)
        }
    }

    // MARK: - Timer Display Section
    private var timerDisplaySection: some View {
        VStack(spacing: 8) {
            Text(appState.session.mode.icon)
                .font(.system(size: 48))

            Text(formatTime(appState.session.remainingSeconds))
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .contentTransition(.numericText())
        }
    }

    // MARK: - Control Buttons Section
    private var controlButtonsSection: some View {
        HStack(spacing: 12) {
            switch appState.session.state {
            case .idle:
                Button("Start") {
                    appState.startTimer(for: appState.session.mode)
                }
                .buttonStyle(.borderedProminent)

            case .running:
                Button("Pause") {
                    appState.pauseTimer()
                }
                .buttonStyle(.bordered)

                Button("Reset") {
                    appState.resetTimer()
                }
                .buttonStyle(.bordered)

            case .paused:
                Button("Resume") {
                    appState.resumeTimer()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    appState.resetTimer()
                }
                .buttonStyle(.bordered)

            case .completed:
                Button("Restart") {
                    appState.startTimer(for: appState.session.mode)
                }
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    appState.resetTimer()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            // Settings Button
            Button {
                showingSettings = true
            } label: {
                Label("Settings", systemImage: "gear")
            }
            .buttonStyle(.bordered)
            
            // Quit Button
            Button {
                quitApplication()
            } label: {
                Label(quitButtonText, systemImage: "power")
            }
            .buttonStyle(.bordered)
            .help("Quit Sharp Timer")
        }
    }

    // MARK: - Private Helpers
    private func switchToMode(_ mode: TimerMode) {
        appState.switchToMode(mode)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func quitApplication() {
        if appState.session.state == .running || appState.session.state == .paused {
            // Timer is active, show confirmation
            if quitButtonText == "Quit" {
                quitButtonText = "Confirm Quit"
            } else {
                NSApplication.shared.terminate(nil)
            }
        } else {
            // Timer is not active, quit directly
            NSApplication.shared.terminate(nil)
        }
    }
}

#Preview {
    TimerDisplayView()
        .environment(AppState())
}
