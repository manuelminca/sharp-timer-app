import SwiftUI
import AppKit

struct QuitOptionsView: View {
    @Environment(AppState.self) private var appState
    let onClose: () -> Void
    
    // Direct window access for cancel
    private func closeWindow() {
        print("🔹 closeWindow called")
        onClose()
        print("🔹 onClose callback completed")
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quit Sharp Timer?")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 24)
            
            Text("Your timer is still running. What would you like to do?")
                .font(.body)
                .foregroundColor(.secondary)
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
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    persistAndQuit()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 16, weight: .medium))
                        Text("Quit app and leave timer running")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button("Cancel") {
                    cancel()
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.gray.opacity(0.15))
                .foregroundColor(.primary)
                .cornerRadius(10)
                .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 24)
        }
        .frame(width: 380, height: 260)
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