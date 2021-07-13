//
//  ToneGenerate.swift
//  pjsip-sample-configuration
//
//  Created by Now Software on 7/8/21.
//

import Foundation
import AVFoundation
import AudioToolbox

class ToneGenerator {
    
    var player: AVAudioPlayer?
    var currentVolume:Float = 0
    
    
    init() {
        
    }
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "iphoneTone", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.numberOfLoops = 2

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
            currentVolume = player.volume
            setVibration()


        } catch let error {
            print("TONE GENERATOR ERROR: \(error.localizedDescription)")
        }
    }
    
    func setVibration(){
                
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
    }
    
    func stopSound() {
        
        player?.stop()
        
    }
    
    func volumeUp() {
                
        player?.setVolume(currentVolume, fadeDuration: 1)
        
    }
    
    func volumeDown(){
                
        player?.setVolume(0.3, fadeDuration: 1)
        
    }
    
}
