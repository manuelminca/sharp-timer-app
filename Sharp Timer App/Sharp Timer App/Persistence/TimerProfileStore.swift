//
//  TimerProfileStore.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation

// MARK: - Timer Persistence Snapshot
struct TimerPersistenceSnapshot: Codable {
    let modeID: String
    let remainingSeconds: Int
    let isRunning: Bool
    let resumedAt: Date?
    let targetDate: Date?
    let savedAt: Date
    let schemaVersion: Int
    
    init(modeID: String, remainingSeconds: Int, isRunning: Bool, resumedAt: Date? = nil, targetDate: Date? = nil) {
        self.modeID = modeID
        self.remainingSeconds = remainingSeconds
        self.isRunning = isRunning
        self.resumedAt = resumedAt
        self.targetDate = targetDate
        self.savedAt = Date()
        self.schemaVersion = 2
    }
    
    var isValid: Bool {
        return (1...3600).contains(remainingSeconds) && schemaVersion >= 1 && schemaVersion <= 2
    }
}

struct TimerProfile: Codable {
    var workMinutes: Int
    var restEyesMinutes: Int
    var longRestMinutes: Int
    var lastSelectedMode: TimerMode
    var updatedAt: Date

    init() {
        self.workMinutes = 25
        self.restEyesMinutes = 2
        self.longRestMinutes = 15
        self.lastSelectedMode = .work
        self.updatedAt = Date()
    }

    func validating() -> TimerProfile {
        var validated = self
        validated.workMinutes = max(1, min(240, workMinutes))
        validated.restEyesMinutes = max(1, min(240, restEyesMinutes))
        validated.longRestMinutes = max(1, min(240, longRestMinutes))
        validated.updatedAt = Date()
        return validated
    }
}

@MainActor
@Observable
class TimerProfileStore {
    private let userDefaults = UserDefaults.standard
    private let profileKey = "com.sharp-timer.profile"
    private let timerStateKey = "com.sharp-timer.timer-state"
    
    private let fileManager = FileManager.default
    @ObservationIgnored private lazy var supportDirectory: URL = {
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let supportDir = urls.first!.appendingPathComponent("Sharp Timer")
        try? fileManager.createDirectory(at: supportDir, withIntermediateDirectories: true)
        return supportDir
    }()
    @ObservationIgnored private lazy var timerStateFileURL: URL = supportDirectory.appendingPathComponent("timer-state.json")

    private(set) var profile: TimerProfile

    init() {
        if let data = userDefaults.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(TimerProfile.self, from: data) {
            self.profile = decoded.validating()
        } else {
            self.profile = TimerProfile()
            save()
        }
    }

    func updateWorkMinutes(_ minutes: Int) {
        profile.workMinutes = minutes
        save()
    }

    func updateRestEyesMinutes(_ minutes: Int) {
        profile.restEyesMinutes = minutes
        save()
    }

    func updateLongRestMinutes(_ minutes: Int) {
        profile.longRestMinutes = minutes
        save()
    }

    func updateLastSelectedMode(_ mode: TimerMode) {
        profile.lastSelectedMode = mode
        save()
    }

    // MARK: - Timer State Persistence
    func saveTimerState(_ snapshot: TimerPersistenceSnapshot) async {
        guard snapshot.isValid else { return }
        
        do {
            let data = try JSONEncoder().encode(snapshot)
            try data.write(to: timerStateFileURL)
            
            // Also save a quick flag in UserDefaults for fast checks
            userDefaults.set(true, forKey: timerStateKey)
        } catch {
            print("Failed to save timer state: \(error)")
        }
    }
    
    func loadTimerState() async -> TimerPersistenceSnapshot? {
        guard userDefaults.bool(forKey: timerStateKey) else { return nil }
        
        do {
            let data = try Data(contentsOf: timerStateFileURL)
            let snapshot = try JSONDecoder().decode(TimerPersistenceSnapshot.self, from: data)
            return snapshot.isValid ? snapshot : nil
        } catch {
            print("Failed to load timer state: \(error)")
            // Clear the flag if file is corrupted
            userDefaults.removeObject(forKey: timerStateKey)
            return nil
        }
    }
    
    func clearTimerState() async {
        userDefaults.removeObject(forKey: timerStateKey)
        try? fileManager.removeItem(at: timerStateFileURL)
    }
    
    private func save() {
        let validated = profile.validating()
        profile = validated
        if let encoded = try? JSONEncoder().encode(validated) {
            userDefaults.set(encoded, forKey: profileKey)
        }
    }
}
