//
//  Sounds.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/17/22.
//

import UIKit
import AVFAudio

enum ExtensionString: String {
    case mp3
    case wav
}

enum Sound: String {
    
    static var players: [Sound: AVAudioPlayer] = [:]

    case music1
    case pageFlip
    case pop
    
    var player: AVAudioPlayer? {
        Sound.players[self]
    }
    
    func play(extensionString: ExtensionString) {
        let url = Bundle.main.path(forResource: self.rawValue, ofType: extensionString.rawValue)
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let url = url else {
                return
            }
            Sound.players[self] = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            guard let player = Sound.players[self] else {
                return
            }
            player.play()
        }
        catch {
            print(error)
        }
    }
    
    func stop() {
        if let player = Sound.players[self] {
            player.stop()
        }
    }
}

