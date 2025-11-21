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
        VStack(spacing: 24) {
            Text("Quit Sharp Timer?")
                .font(BauhausTheme.headerFont)
                .foregroundColor(BauhausTheme.text)
                .padding(.top, 24)

            Text("Your timer is still running. What would you like to do?")
                .font(BauhausTheme.bodyFont)
                .foregroundColor(BauhausTheme.text.opacity(0.7))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                Button(action: {
                    stopTimerAndQuit()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Stop timer and quit app")
                            .font(BauhausTheme.buttonFont)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(BauhausTheme.primaryRed)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    persistAndQuit()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 16, weight: .medium))
                        Text("Quit app and leave timer running")
                            .font(BauhausTheme.buttonFont)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(BauhausTheme.primaryBlue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button("Cancel") {
                    cancel()
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(BauhausTheme.surface)
                .foregroundColor(BauhausTheme.text)
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .font(BauhausTheme.buttonFont)
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 24)
        }
        .frame(width: 400, height: 280)
        .background(Color.clear)
        .onKeyPress(.escape) {
            closeWindow()
            return .handled
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