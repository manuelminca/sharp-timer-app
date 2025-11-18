//
//  AppState.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import SwiftUI
import Combine
import UserNotifications

@MainActor
@Observable
class AppState {
    // MARK: - Core Components
    private let engine = TimerEngine()
    private let profileStore = TimerProfileStore()
    private let alarmPlayer = AlarmPlayerService()

    // MARK: - Notification Properties
    private var notificationPreference = NotificationPreference()
    
    // MARK: - Intent Properties
    private var modeSwitchIntent: ModeSwitchIntent?
    private var quitIntent: QuitIntent?

    // MARK: - Published Properties
    var session: TimerSession { engine.session }
    var profile: TimerProfile { profileStore.profile }
    var alarmPlaybackState: AlarmPlaybackState { alarmPlayer.playbackState }

    // MARK: - Initialization
    init() {
        // Set up timer completion callback
        engine.onTimerCompletion = { [weak self] in
            self?.handleTimerCompletion()
        }
        
        Task {
            await refreshNotificationStatus()
            await loadPersistedTimerState()
        }
    }

    // MARK: - Timer Control Actions
    func startTimer(for mode: TimerMode) {
        let duration = durationForMode(mode)
        engine.start(mode: mode, durationSeconds: duration)
        profileStore.updateLastSelectedMode(mode)
    }

    func pauseTimer() {
        engine.pause()
    }

    func resumeTimer() {
        engine.resume()
    }

    func resetTimer() {
        engine.reset()
    }
    
    func switchToMode(_ mode: TimerMode) {
        // Check if timer is running and requires confirmation
        if session.state == .running {
            modeSwitchIntent = ModeSwitchIntent(
                requestedMode: mode,
                initiatedAt: Date(),
                confirmationState: .pending,
                originatingView: .popover
            )
            
            // Show confirmation dialog
            showModeSwitchConfirmation()
            return
        }
        
        // Direct switch if timer is not running
        performModeSwitch(to: mode)
    }
    
    func confirmModeSwitch() {
        guard let intent = modeSwitchIntent else { return }
        performModeSwitch(to: intent.requestedMode)
        modeSwitchIntent = nil
    }
    
    func cancelModeSwitch() {
        modeSwitchIntent = nil
    }
    
    private func performModeSwitch(to mode: TimerMode) {
        // Reset current timer if running
        if session.state != .idle {
            engine.reset()
        }
        
        // Create new session with the selected mode and its default duration
        let duration = durationForMode(mode)
        engine.start(mode: mode, durationSeconds: duration)
        profileStore.updateLastSelectedMode(mode)
    }

    // MARK: - Settings Actions
    func updateWorkMinutes(_ minutes: Int) {
        profileStore.updateWorkMinutes(minutes)
    }

    func updateRestEyesMinutes(_ minutes: Int) {
        profileStore.updateRestEyesMinutes(minutes)
    }

    func updateLongRestMinutes(_ minutes: Int) {
        profileStore.updateLongRestMinutes(minutes)
    }

    // MARK: - Computed Properties
    func durationForMode(_ mode: TimerMode) -> Int {
        switch mode {
        case .work:
            return profile.workMinutes * 60
        case .restEyes:
            return profile.restEyesMinutes * 60
        case .longRest:
            return profile.longRestMinutes * 60
        }
    }

    var menuBarTitle: String {
        "\(session.mode.icon) \(formatTime(session.remainingSeconds))"
    }

    // MARK: - Notification Methods
    func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                notificationPreference.authorizationStatus = granted ? .granted : .denied
                notificationPreference.needsFallbackBanner = !granted
                notificationPreference.lastRequestDate = Date()
            }
        } catch {
            await MainActor.run {
                notificationPreference.authorizationStatus = .denied
                notificationPreference.needsFallbackBanner = true
                notificationPreference.lastFailureReason = error.localizedDescription
                notificationPreference.lastRequestDate = Date()
            }
        }
    }

    func scheduleCompletionNotification(for session: TimerSession) {
        guard notificationPreference.authorizationStatus == .granted else {
            notificationPreference.needsFallbackBanner = true
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "\(session.mode.displayName) Complete"
        content.body = "Time for a break!"
        content.sound = .default

        // Add actions for restart/dismiss
        let dismissAction = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: []
        )
        let restartAction = UNNotificationAction(
            identifier: "restart",
            title: "Restart",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "timer_complete",
            actions: [dismissAction, restartAction],
            intentIdentifiers: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = "timer_complete"

        // Schedule notification for immediate delivery (timer already completed)
        let request = UNNotificationRequest(
            identifier: "timer_complete_\(session.mode.rawValue)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil // Immediate
        )

        UNUserNotificationCenter.current().add(request) { error in
            Task { @MainActor in
                if let error = error {
                    self.notificationPreference.needsFallbackBanner = true
                    self.notificationPreference.lastFailureReason = error.localizedDescription
                }
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func refreshNotificationStatus() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        await MainActor.run {
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                notificationPreference.authorizationStatus = .granted
                notificationPreference.needsFallbackBanner = false
            case .denied:
                notificationPreference.authorizationStatus = .denied
                notificationPreference.needsFallbackBanner = true
            case .notDetermined, .ephemeral:
                notificationPreference.authorizationStatus = .unknown
                notificationPreference.needsFallbackBanner = false
            @unknown default:
                notificationPreference.authorizationStatus = .unknown
                notificationPreference.needsFallbackBanner = false
            }
        }
    }

    // MARK: - Notification Handling
    func handleTimerCompletion() {
        // This method is now called automatically by TimerEngine when timer completes
        Task {
            await alarmPlayer.playAlarm()
        }
        scheduleCompletionNotification(for: session)
    }
    
    // MARK: - Timer State Persistence
    func saveTimerState() async {
        guard session.state == .running else { return }
        
        let snapshot = TimerPersistenceSnapshot(
            modeID: session.mode.rawValue,
            remainingSeconds: session.remainingSeconds,
            isRunning: session.state == .running,
            resumedAt: session.startedAt
        )
        
        await profileStore.saveTimerState(snapshot)
    }
    
    func clearTimerState() async {
        await profileStore.clearTimerState()
    }
    
    private func loadPersistedTimerState() async {
        guard let snapshot = await profileStore.loadTimerState() else { return }
        
        // Restore timer state
        let mode = TimerMode(rawValue: snapshot.modeID) ?? .work
        engine.start(mode: mode, durationSeconds: snapshot.remainingSeconds)
        
        if !snapshot.isRunning {
            engine.pause()
        }
        
        // Clear the persisted state after loading
        await profileStore.clearTimerState()
    }
    
    // MARK: - Quit Handling
    func handleQuitRequest() -> QuitIntent {
        if session.state == .running {
            quitIntent = QuitIntent(
                action: .cancel,
                handled: false,
                snapshot: nil
            )
        } else {
            quitIntent = QuitIntent(
                action: .stopAndQuit,
                handled: false,
                snapshot: nil
            )
        }
        return quitIntent!
    }
    
    func processQuitIntent(_ action: QuitIntent.QuitAction) async {
        switch action {
        case .stopAndQuit:
            engine.reset()
            await clearTimerState()
            
        case .persistAndQuit:
            let snapshot = TimerPersistenceSnapshot(
                modeID: session.mode.rawValue,
                remainingSeconds: session.remainingSeconds,
                isRunning: session.state == .running,
                resumedAt: session.startedAt
            )
            await profileStore.saveTimerState(snapshot)
            
        case .cancel:
            break
        }
        
        quitIntent?.handled = true
    }

    // MARK: - UI Presentation
    func showModeSwitchConfirmation() {
        guard let intent = modeSwitchIntent else { return }
        
        let windowController = ModeSwitchConfirmationWindowController(
            intent: intent,
            appState: self
        )
        windowController.show()
    }
    
    func showQuitConfirmation(completion: @escaping () -> Void) {
        let intent = handleQuitRequest()
        
        let windowController = QuitConfirmationWindowController(
            intent: intent,
            appState: self,
            onCompletion: completion
        )
        windowController.show()
    }
    
    // MARK: - Private Helpers
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Supporting Types
struct ModeSwitchIntent {
    let requestedMode: TimerMode
    let initiatedAt: Date
    var confirmationState: ConfirmationState
    let originatingView: OriginatingView
    
    enum ConfirmationState {
        case pending
        case confirmed
        case cancelled
    }
    
    enum OriginatingView {
        case popover
        case settings
    }
}

struct QuitIntent {
    var action: QuitAction
    var handled: Bool
    var snapshot: TimerPersistenceSnapshot?
    
    enum QuitAction {
        case stopAndQuit
        case persistAndQuit
        case cancel
    }
}
