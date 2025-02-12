//
//  WordSynthesizer.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import AVFoundation

protocol WordSynthesizing {
    func speak(_ text: String)
}

final class WordSynthesizer: WordSynthesizing {
    
    private let speechSynthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}
