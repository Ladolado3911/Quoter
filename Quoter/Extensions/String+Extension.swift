//
//  String+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/4/22.
//

import UIKit
import AVFoundation

let preferedVoices = ["com.apple.ttsbundle.Tessa-compact", "com.apple.ttsbundle.Karen-compact", "com.apple.ttsbundle.Moira-compact"]

extension String {
    
    var randomPerson: String {
        return AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.contains("en") && $0.gender == .female }
            .map { $0.identifier }
            .randomElement()!
    }
    
    func speak() {
        let voice = AVSpeechSynthesisVoice(identifier: randomPerson)
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = voice

        print(voice?.gender)
        print(voice?.quality)
        print(voice?.language)
        print(voice?.identifier)
        print(utterance.pitchMultiplier)
        synthesizer.speak(utterance)
        //var utteranceArr: [AVSpeechUtterance] = []
//
//        for word in wordsArr {
//            let utternace = AVSpeechUtterance(string: word)
//            utternace.voice = voice
//            synthesizer.speak(utternace)
//        }
//        utterance.pitchMultiplier = 0.8
//        utterance.postUtteranceDelay = 0
//        utterance.preUtteranceDelay = 0
        //utterance.prefersAssistiveTechnologySettings = false
        //utterance.voice = AVSpeechSynthesisVoice(identifier: "Catherine")
    }
}

class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    
    let synth = AVSpeechSynthesizer()
//
//    var utterance1: AVSpeechUtterance?
//    var utterance2: AVSpeechUtterance?
//
    var words: [String] = []
    var utterances: [AVSpeechUtterance] = []

    func speak(string: String) {
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.delegate = self
//        utterance1 = AVSpeechUtterance(string: string)
//        utterance2 = AVSpeechUtterance(string: string)
//        guard let utterance1 = utterance1 else {
//            return
//        }
//        guard let utterance2 = utterance2 else {
//            return
//        }
//
        words = (string.split(separator: " ")).map { String($0) }
        words.forEach {
            let utterance = AVSpeechUtterance(string: $0)
            utterance.voice = voice
            utterances.append(utterance)
            
            
            
            synth.speak(utterance)
        }

        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print(#function)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print(#function)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print(#function)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print(#function)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print(#function)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //print(#function)
//        if characterRange.lowerBound >= 20 && !isZero {
//            utterance.pitchMultiplier = 0
//            isZero = true
//        }
        
    }
}

