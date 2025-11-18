//
//  TestFixtures.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation
@testable import Sharp_Timer_App

// MARK: - Test Fixtures
class TestFixtures {
    
    // MARK: - Timer Persistence Snapshot Fixtures
    static let validSnapshot = TimerPersistenceSnapshot(
        modeID: "work",
        remainingSeconds: 1500,
        isRunning: true,
        resumedAt: Date()
    )
    
    static let invalidSnapshot = TimerPersistenceSnapshot(
        modeID: "work",
        remainingSeconds: 5000, // Invalid: exceeds 3600 seconds
        isRunning: true,
        resumedAt: Date()
    )
    
    static let completedSnapshot = TimerPersistenceSnapshot(
        modeID: "rest_eyes",
        remainingSeconds: 0,
        isRunning: false,
        resumedAt: nil
    )
    
    // MARK: - Timer Profile Fixtures
    static let defaultProfile = TimerProfile()
    
    static let customProfile: TimerProfile = {
        var profile = TimerProfile()
        profile.workMinutes = 30
        profile.restEyesMinutes = 5
        profile.longRestMinutes = 20
        profile.lastSelectedMode = .longRest
        profile.updatedAt = Date()
        return profile
    }()
    
    // MARK: - Mock Alarm Player Service
    class MockAlarmPlayerService: AlarmPlayerService {
        var playCallCount = 0
        var stopCallCount = 0
        var shouldFailPlayback = false
        
        override func playAlarm() async {
            playCallCount += 1
            if shouldFailPlayback {
                playbackState.status = .failed
                playbackState.fallbackUsed = true
                playbackState.lastError = AlarmPlayerError.playerNotInitialized
            } else {
                playbackState.status = .playing
                playbackState.fallbackUsed = false
                playbackState.lastError = nil
            }
        }
        
        override func stopAlarm() {
            stopCallCount += 1
            playbackState.status = .idle
        }
    }
    
    // MARK: - Mock Timer Profile Store
    class MockTimerProfileStore: TimerProfileStore {
        var saveTimerStateCallCount = 0
        var loadTimerStateCallCount = 0
        var clearTimerStateCallCount = 0
        var mockSnapshot: TimerPersistenceSnapshot?
        var shouldFailSave = false
        var shouldFailLoad = false
        
        override func saveTimerState(_ snapshot: TimerPersistenceSnapshot) async {
            saveTimerStateCallCount += 1
            if !shouldFailSave {
                mockSnapshot = snapshot
            }
        }
        
        override func loadTimerState() async -> TimerPersistenceSnapshot? {
            loadTimerStateCallCount += 1
            if !shouldFailLoad {
                return mockSnapshot
            }
            return nil
        }
        
        override func clearTimerState() async {
            clearTimerStateCallCount += 1
            mockSnapshot = nil
        }
    }
    
    // MARK: - JSON Encoding/Decoding Helpers
    static func encodeSnapshot(_ snapshot: TimerPersistenceSnapshot) -> Data? {
        return try? JSONEncoder().encode(snapshot)
    }
    
    static func decodeSnapshot(from data: Data) -> TimerPersistenceSnapshot? {
        return try? JSONDecoder().decode(TimerPersistenceSnapshot.self, from: data)
    }
    
    // MARK: - File System Helpers
    static func createTempTimerStateFile() throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let tempFile = tempDir.appendingPathComponent("test-timer-state.json")
        return tempFile
    }
    
    static func cleanupTempFile(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
    // MARK: - Date Helpers
    static func fixedDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: 2025, month: 11, day: 17, hour: 12, minute: 0, second: 0)
        return calendar.date(from: components) ?? Date()
    }
    
    static func date(minutesFromNow minutes: Int) -> Date {
        return Date().addingTimeInterval(TimeInterval(minutes * 60))
    }
    
    // MARK: - Test Data Factory
    static func createSnapshot(
        mode: TimerMode = .work,
        remainingSeconds: Int = 1500,
        isRunning: Bool = true,
        resumedAt: Date? = nil
    ) -> TimerPersistenceSnapshot {
        return TimerPersistenceSnapshot(
            modeID: mode.rawValue,
            remainingSeconds: remainingSeconds,
            isRunning: isRunning,
            resumedAt: resumedAt
        )
    }
    
    static func createProfile(
        workMinutes: Int = 25,
        restEyesMinutes: Int = 2,
        longRestMinutes: Int = 15,
        lastSelectedMode: TimerMode = .work
    ) -> TimerProfile {
        var profile = TimerProfile()
        profile.workMinutes = workMinutes
        profile.restEyesMinutes = restEyesMinutes
        profile.longRestMinutes = longRestMinutes
        profile.lastSelectedMode = lastSelectedMode
        profile.updatedAt = Date()
        return profile
    }
}

// MARK: - Test Extensions
extension TimerPersistenceSnapshot {
    static func == (lhs: TimerPersistenceSnapshot, rhs: TimerPersistenceSnapshot) -> Bool {
        return lhs.modeID == rhs.modeID &&
               lhs.remainingSeconds == rhs.remainingSeconds &&
               lhs.isRunning == rhs.isRunning &&
               lhs.schemaVersion == rhs.schemaVersion
    }
}

extension TimerProfile {
    static func == (lhs: TimerProfile, rhs: TimerProfile) -> Bool {
        return lhs.workMinutes == rhs.workMinutes &&
               lhs.restEyesMinutes == rhs.restEyesMinutes &&
               lhs.longRestMinutes == rhs.longRestMinutes &&
               lhs.lastSelectedMode == rhs.lastSelectedMode
    }
}
