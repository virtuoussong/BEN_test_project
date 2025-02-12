//
//  WordSynthesizer.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import AVFoundation

protocol WordSynthesizing: AnyObject {
    func speak(_ text: String)
    var didFinishSpeaking: (() -> Void)? { get set }
}

final class WordSynthesizer: NSObject, WordSynthesizing, AVSpeechSynthesizerDelegate {
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var didFinishSpeaking: (() -> Void)?
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    func speak(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishSpeaking?()
    }
}
