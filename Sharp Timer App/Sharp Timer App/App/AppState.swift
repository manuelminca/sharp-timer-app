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
    

    // MARK: - Published Properties
    var session: TimerSession { engine.session }
    var profile: TimerProfile { profileStore.profile }
    var alarmPlaybackState: AlarmPlaybackState { alarmPlayer.playbackState }

    // MARK: - Initialization
    init() {
        // Initialize the timer session with the persisted profile settings
        initializeTimerSession()
        
        // Set up timer completion callback
        engine.onTimerCompletion = { [weak self] in
            self?.handleTimerCompletion()
        }
        
        Task {
            await refreshNotificationStatus()
            await restorePersistedState()
        }
    }
    
    // MARK: - Private Initialization
    private func initializeTimerSession() {
        // Get the last selected mode or default to work
        let lastMode = profileStore.profile.lastSelectedMode
        let duration = durationForMode(lastMode)
        
        // Create a new session with the correct duration
        let newSession = TimerSession(mode: lastMode, configuredSeconds: duration)
        engine.session = newSession
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
    
    func stopTimer() {
        engine.reset()
    }
    
    func switchToMode(_ mode: TimerMode) {
        // Direct switch without confirmation
        performModeSwitch(to: mode)
    }

    private func performModeSwitch(to mode: TimerMode) {
        let duration = durationForMode(mode)

        if session.state == .running {
            // If running, reset to new mode with full duration
            if profile.autoStartOnModeChange ?? false {
                // Auto-start enabled: continue running
                engine.changeMode(to: mode, durationSeconds: duration)
            } else {
                // Auto-start disabled: reset and pause
                engine.reset()
                let newSession = TimerSession(mode: mode, configuredSeconds: duration)
                engine.session = newSession
            }
        } else {
            // If idle or paused
            if session.state != .idle {
                engine.reset() // Reset to idle
            }
            // Create new session
            let newSession = TimerSession(mode: mode, configuredSeconds: duration)
            engine.session = newSession

            // Auto-start if enabled and was paused (now idle)
            if profile.autoStartOnModeChange ?? false {
                engine.start(mode: mode, durationSeconds: duration)
            }
        }

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

    func updateAutoStartOnModeChange(_ enabled: Bool) {
        profileStore.updateAutoStartOnModeChange(enabled)
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
        if session.state == .running || session.state == .paused {
            return formatTime(session.remainingSeconds)
        } else {
            return session.mode.icon
        }
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
    
    

    
    
    // MARK: - State Persistence
    func persistState() async {
        guard session.state == .running || session.state == .paused else { return }
        
        let snapshot = TimerPersistenceSnapshot(
            modeID: session.mode.rawValue,
            configuredSeconds: session.configuredSeconds,
            remainingSeconds: session.remainingSeconds,
            state: session.state,
            startedAt: session.startedAt,
            pausedAt: session.pausedAt
        )
        
        await profileStore.saveTimerState(snapshot)
    }
    
    func restorePersistedState() async {
        guard let snapshot = await profileStore.loadTimerState() else { return }
        
        // Restore the timer session
        guard let mode = TimerMode(rawValue: snapshot.modeID) else { return }
        
        let now = Date()
        var adjustedRemainingSeconds = snapshot.remainingSeconds
        var adjustedState = snapshot.state
        
        // Calculate elapsed time since the snapshot was saved
        let elapsedSeconds = Int(now.timeIntervalSince(snapshot.savedAt))
        
        // If the timer was running, calculate the new remaining time
        if snapshot.state == .running {
            adjustedRemainingSeconds = max(0, snapshot.remainingSeconds - elapsedSeconds)
            
            // If time has run out, set to completed state
            if adjustedRemainingSeconds == 0 {
                adjustedState = .completed
            }
        }
        
        let restoredSession = TimerSession(
            mode: mode,
            configuredSeconds: snapshot.configuredSeconds,
            remainingSeconds: adjustedRemainingSeconds,
            state: adjustedState,
            startedAt: snapshot.startedAt,
            pausedAt: snapshot.pausedAt,
            notificationId: nil
        )
        
        engine.session = restoredSession
        
        // If the timer was running and still has time left, resume it
        if snapshot.state == .running && adjustedRemainingSeconds > 0 {
            // Start a new timer session with the adjusted time
            engine.start(mode: mode, durationSeconds: adjustedRemainingSeconds)
        }
        
        // Clear the persisted state after successful restoration
        await profileStore.clearTimerState()
    }

    // MARK: - Private Helpers
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Supporting Types

