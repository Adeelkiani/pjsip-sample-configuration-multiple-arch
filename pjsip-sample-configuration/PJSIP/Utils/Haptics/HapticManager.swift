//
//  HapticManager.swift
//  pjsip-sample-configuration
//
//  Created by Now Software on 7/8/21.
//

import Foundation
import CoreHaptics
import AVFoundation

@available(iOS 13.0, *)
class HapticManager {
  // 1
    var engine: CHHapticEngine?

  // 2
  init?() {
    
    createEngine()
  }
    
    
    func createEngine() {
        // Create and configure a haptic engine.
        do {
            // Associate the haptic engine with the default audio session
            // to ensure the correct behavior when playing audio-based haptics.
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        guard let engine = engine else {
            print("Failed to create engine!")
            return
        }
        
        // The stopped handler alerts you of engine stoppage due to external causes.
        engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
 
        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }

    
    
    func playSlice() {
      do {
        // 1
        let pattern = try slicePattern()
        // 2
        try engine?.start()
        // 3
        let player = try engine?.makePlayer(with: pattern)
        // 4
        try player?.start(atTime: 0)
        // 5
        
        
      } catch {
        print("Failed to play slice: \(error)")
      }
    }
}

@available(iOS 13.0, *)
extension HapticManager {
  private func slicePattern() throws -> CHHapticPattern {
    let slice = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.35),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
      ],
      relativeTime: 0,
      duration: 0.25)

    let snip = CHHapticEvent(
      eventType: .hapticTransient,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
      ],
      relativeTime: 0.08)

    return try CHHapticPattern(events: [slice, snip], parameters: [])
  }
}
