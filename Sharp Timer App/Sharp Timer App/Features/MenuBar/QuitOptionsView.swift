import SwiftUI
import AppKit

struct QuitOptionsView: View {
    @Environment(AppState.self) private var appState
    let onClose: () -> Void
    
    // Direct window access for cancel
    private func closeWindow() {
        onClose()
    }
    
    var body: some View {
        ZStack {
            // Background with decorative Bauhaus elements
            BauhausTheme.background
                .ignoresSafeArea()
            
            // Decorative geometric elements
            decorativeBackgroundElements
            
            // Main content card
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Warning message (if timer is running)
                if appState.session.state == .running || appState.session.state == .paused {
                    warningSection
                }
                
                // Options
                optionsSection
                
                // Decorative elements
                decorativeElements
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(BauhausTheme.surface)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(12)
        }
        .frame(minWidth: 400, idealWidth: 450, maxWidth: 500, minHeight: 400, idealHeight: 450, maxHeight: 500)
        .onKeyPress(.escape) {
            closeWindow()
            return .handled
        }
    }
    
    // MARK: - Decorative Background Elements
    private var decorativeBackgroundElements: some View {
        ZStack {
            // Top left circle
            Circle()
                .fill(BauhausTheme.primaryRed.opacity(0.2))
                .frame(width: 64, height: 64)
                .position(x: 40, y: 40)
            
            // Bottom right square
            Rectangle()
                .fill(BauhausTheme.primaryYellow.opacity(0.2))
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(45))
                .position(x: -40, y: -40)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(BauhausTheme.primaryRed)
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "power")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                )
            
            Text("Quit Application")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(BauhausTheme.text)
                .textCase(.uppercase)
                .tracking(1)
            
            Spacer()
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Warning Section
    private var warningSection: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(BauhausTheme.text)
                .frame(width: 4, height: 32)
            
            Text("Timer is currently running")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(BauhausTheme.text)
                .textCase(.uppercase)
                .tracking(0.5)
            
            Spacer()
        }
        .padding(16)
        .background(BauhausTheme.primaryYellow)
        .padding(.bottom, 16)
    }
    
    // MARK: - Options Section
    private var optionsSection: some View {
        VStack(spacing: 12) {
            // Stop and Quit
            Button(action: {
                stopTimerAndQuit()
            }) {
                HStack(spacing: 16) {
                    Circle()
                        .stroke(.white, lineWidth: 1.5)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "power")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Stop Timer and Quit App")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        Text("Timer will be stopped and reset")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(BauhausTheme.primaryRed)
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            
            // Quit with timer running
            if appState.session.state == .running || appState.session.state == .paused {
                Button(action: {
                    persistAndQuit()
                }) {
                    HStack(spacing: 16) {
                        Circle()
                            .stroke(.white, lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Quit App and Leave Timer Running")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            Text("Timer continues in background")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(BauhausTheme.primaryBlue)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
            }
            
            // Cancel
            Button(action: {
                cancel()
            }) {
                HStack(spacing: 16) {
                    Circle()
                        .stroke(BauhausTheme.text, lineWidth: 1.5)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(BauhausTheme.text)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cancel")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(BauhausTheme.text)
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        Text("Return to timer")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(BauhausTheme.text.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(BauhausTheme.text, lineWidth: 1.5)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Decorative Elements
    private var decorativeElements: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(BauhausTheme.primaryRed)
                .frame(width: 16, height: 16)
            
            Circle()
                .fill(BauhausTheme.primaryBlue)
                .frame(width: 16, height: 16)
            
            Rectangle()
                .fill(BauhausTheme.primaryYellow)
                .frame(width: 16, height: 16)
                .rotationEffect(.degrees(45))
        }
    }
    
    // MARK: - Actions
    private func stopTimerAndQuit() {
        appState.stopTimer()
        NSApplication.shared.terminate(nil)
    }
    
    private func persistAndQuit() {
        Task {
            await appState.persistState()
            NSApplication.shared.terminate(nil)
        }
    }
    
    private func cancel() {
        closeWindow()
    }
}

#Preview {
    QuitOptionsView(onClose: {})
        .environment(AppState())
}
