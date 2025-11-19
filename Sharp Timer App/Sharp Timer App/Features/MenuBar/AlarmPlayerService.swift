//
//  AlarmPlayerService.swift
//  Sharp Timer App
//
//  Created by Manuel Minguez on 17/11/25.
//

import Foundation
import AVFoundation
import UserNotifications
import AppKit
import os.log
import AudioToolbox

// MARK: - Alarm Playback State
struct AlarmPlaybackState {
    var fileURL: URL
    var status: PlaybackStatus
    var lastError: Error?
    var fallbackUsed: Bool
    var volume: Double = 1.0
    var isLooping: Bool = false
    var playbackDuration: TimeInterval = 0.0
    
    enum PlaybackStatus {
        case idle
        case playing
        case paused
        case failed
    }
}

// MARK: - Alarm Player Service
@MainActor
@Observable
class AlarmPlayerService {
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    var playbackState: AlarmPlaybackState
    
    private let logger = Logger(subsystem: "com.sharptimer.app", category: "AlarmPlayer")
    
    init() {
        // Try to load the alarm sound file
        var alarmURL: URL
        var fallbackUsed = false
        
        if let foundAlarmURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
            alarmURL = foundAlarmURL
            logger.info("Alarm sound loaded: alarm.mp3")
        } else {
            // Create a dummy URL if no sound files are found
            alarmURL = URL(fileURLWithPath: "/dev/null")
            fallbackUsed = true
            logger.warning("No alarm sound file found, will use system sounds")
        }
        
        self.playbackState = AlarmPlaybackState(
            fileURL: alarmURL,
            status: .idle,
            lastError: nil,
            fallbackUsed: fallbackUsed
        )
        
        preloadAlarmSound()
    }
    
    // MARK: - Public Methods
    func playAlarm() async {
        logger.info("Attempting to play alarm: \(self.playbackState.fileURL.lastPathComponent)")
        
        if let player = player {
            // Reset to beginning and configure playback
            player.currentTime = 0
            player.volume = Float(playbackState.volume)
            player.numberOfLoops = playbackState.isLooping ? -1 : 0 // -1 = infinite loop
            
            player.play()
            playbackState.status = .playing
            playbackState.lastError = nil
            
            // Start tracking playback duration
            startPlaybackTimer()
            
            logger.info("Alarm started playing successfully: \(self.playbackState.fileURL.lastPathComponent)")
        } else {
            logger.warning("Failed to play alarm - player not initialized, using fallback")
            playbackState.status = .failed
            playbackState.lastError = AlarmPlayerError.playerNotInitialized
            playbackState.fallbackUsed = true
            
            // Fallback to system notification sound
            await playFallbackNotification()
        }
    }
    
    func stopAlarm() {
        player?.stop()
        timer?.invalidate()
        timer = nil
        playbackState.status = .idle
        playbackState.playbackDuration = 0.0
        print("Alarm stopped")
    }
    
    func pauseAlarm() {
        player?.pause()
        timer?.invalidate()
        timer = nil
        playbackState.status = .paused
        print("Alarm paused")
    }
    
    func resumeAlarm() {
        if let player = player, player.isPlaying == false {
            player.play()
            startPlaybackTimer()
            playbackState.status = .playing
            print("Alarm resumed")
        }
    }
    
    func setVolume(_ volume: Double) {
        playbackState.volume = max(0.0, min(1.0, volume)) // Clamp between 0.0 and 1.0
        player?.volume = Float(playbackState.volume)
    }
    
    func setLooping(_ looping: Bool) {
        playbackState.isLooping = looping
        if let player = player {
            player.numberOfLoops = looping ? -1 : 0
        }
    }
    
    // MARK: - Private Methods
    
    private func preloadAlarmSound() {
        guard playbackState.fileURL.path != "/dev/null" else {
            print("No valid alarm file to preload")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: playbackState.fileURL)
            player?.prepareToPlay()
            player?.volume = Float(playbackState.volume)
            player?.numberOfLoops = playbackState.isLooping ? -1 : 0
            
            // Get duration for tracking
            if let duration = player?.duration {
                playbackState.playbackDuration = duration
                logger.info("Alarm sound preloaded successfully. Duration: \(duration) seconds")
            }
        } catch {
            playbackState.lastError = error
            logger.error("Failed to preload alarm sound: \(error.localizedDescription)")
        }
    }
    
    private func startPlaybackTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, let player = self.player else { return }
                
                if player.isPlaying {
                    self.playbackState.playbackDuration = player.currentTime
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    if self.playbackState.status == .playing {
                        self.playbackState.status = .idle
                    }
                }
            }
        }
    }
    
    private func playFallbackNotification() async {
        logger.info("Playing fallback alarm sounds")
        
        // Use AppKit's NSSound for macOS-compatible sound playback
        if let systemSound = NSSound(named: "Morse") {
            systemSound.play()
            playbackState.fallbackUsed = true
            logger.info("Playing Morse system sound")
        } else {
            // Final fallback to system beep
            NSSound.beep()
            playbackState.fallbackUsed = true
            logger.info("Playing system beep")
        }
        
        // Play multiple beeps for better notification
        for i in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                NSSound.beep()
            }
        }
        
        // Also show notification for visual feedback
        let content = UNMutableNotificationContent()
        content.title = "⏰ Timer Complete"
        content.body = "Your timer has finished! Time for a break!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "alarm_fallback_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            logger.info("Fallback notification sent")
        } catch {
            logger.error("Failed to play fallback notification: \(error.localizedDescription)")
        }
    }
}

// MARK: - Error Types
enum AlarmPlayerError: Error, LocalizedError {
    case playerNotInitialized
    case fileNotFound
    
    var errorDescription: String? {
        switch self {
        case .playerNotInitialized:
            return "Audio player not initialized"
        case .fileNotFound:
            return "Alarm sound file not found"
        }
    }
}
