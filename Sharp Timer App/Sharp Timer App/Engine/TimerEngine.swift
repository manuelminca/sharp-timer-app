//
//  TimerEngine.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation
import Combine

enum TimerSessionState: String, Codable {
    case idle
    case running
    case paused
    case completed
}

struct TimerSession: Codable, Equatable {
    let mode: TimerMode
    let configuredSeconds: Int
    var remainingSeconds: Int
    var state: TimerSessionState
    let startedAt: Date?
    let pausedAt: Date?
    var notificationId: String?

    init(mode: TimerMode, configuredSeconds: Int) {
        self.mode = mode
        self.configuredSeconds = configuredSeconds
        self.remainingSeconds = configuredSeconds
        self.state = .idle
        self.startedAt = nil
        self.pausedAt = nil
        self.notificationId = nil
    }

    // For state transitions
    private init(
        mode: TimerMode,
        configuredSeconds: Int,
        remainingSeconds: Int,
        state: TimerSessionState,
        startedAt: Date?,
        pausedAt: Date?,
        notificationId: String?
    ) {
        self.mode = mode
        self.configuredSeconds = configuredSeconds
        self.remainingSeconds = remainingSeconds
        self.state = state
        self.startedAt = startedAt
        self.pausedAt = pausedAt
        self.notificationId = notificationId
    }

    func starting() -> TimerSession {
        TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: remainingSeconds,
            state: .running,
            startedAt: Date(),
            pausedAt: nil,
            notificationId: nil
        )
    }

    func pausing() -> TimerSession {
        TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: remainingSeconds,
            state: .paused,
            startedAt: startedAt,
            pausedAt: Date(),
            notificationId: nil
        )
    }

    func resuming() -> TimerSession {
        TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: remainingSeconds,
            state: .running,
            startedAt: startedAt,
            pausedAt: nil,
            notificationId: nil
        )
    }

    func resetting() -> TimerSession {
        TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: configuredSeconds,
            state: .idle,
            startedAt: nil,
            pausedAt: nil,
            notificationId: nil
        )
    }

    func completing() -> TimerSession {
        TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: 0,
            state: .completed,
            startedAt: startedAt,
            pausedAt: nil,
            notificationId: nil
        )
    }

    func advancing(by seconds: Int) -> TimerSession {
        let newRemaining = max(0, remainingSeconds - seconds)
        let newState: TimerSessionState = newRemaining == 0 ? .completed : state
        return TimerSession(
            mode: mode,
            configuredSeconds: configuredSeconds,
            remainingSeconds: newRemaining,
            state: newState,
            startedAt: startedAt,
            pausedAt: pausedAt,
            notificationId: notificationId
        )
    }
}

@MainActor
@Observable
class TimerEngine {
    private(set) var session: TimerSession
    private var timer: DispatchSourceTimer?
    private let tickInterval: TimeInterval = 1.0

    init() {
        // Default idle session
        self.session = TimerSession(mode: .work, configuredSeconds: 25 * 60)
    }

    // MARK: - Public Interface

    func start(mode: TimerMode, durationSeconds: Int) {
        // Stop any existing session first (single session rule)
        reset()

        var newSession = TimerSession(mode: mode, configuredSeconds: durationSeconds)
        newSession = newSession.starting()
        session = newSession

        scheduleTimer()
    }

    func pause() {
        guard session.state == .running else { return }
        session = session.pausing()
        stopTimer()
    }

    func resume() {
        guard session.state == .paused else { return }
        session = session.resuming()
        scheduleTimer()
    }

    func reset() {
        stopTimer()
        session = session.resetting()
    }

    // MARK: - Private Implementation

    private func scheduleTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: tickInterval)
        timer?.setEventHandler { [weak self] in
            Task { @MainActor in
                self?.tick()
            }
        }
        timer?.resume()
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func tick() {
        session = session.advancing(by: Int(tickInterval))

        if session.state == .completed {
            stopTimer()
            // Completion notification will be handled by AppState
        }
    }
}
