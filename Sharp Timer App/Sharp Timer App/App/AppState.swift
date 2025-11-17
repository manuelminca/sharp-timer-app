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

    // MARK: - Notification Properties
    private var notificationPreference = NotificationPreference()

    // MARK: - Published Properties
    var session: TimerSession { engine.session }
    var profile: TimerProfile { profileStore.profile }

    // MARK: - Initialization
    init() {
        Task {
            await refreshNotificationStatus()
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
        if session.state == .completed {
            scheduleCompletionNotification(for: session)
        }
    }

    // MARK: - Private Helpers
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
