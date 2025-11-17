//
//  TimerProfileStore.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation

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

    private func save() {
        let validated = profile.validating()
        profile = validated
        if let encoded = try? JSONEncoder().encode(validated) {
            userDefaults.set(encoded, forKey: profileKey)
        }
    }
}
