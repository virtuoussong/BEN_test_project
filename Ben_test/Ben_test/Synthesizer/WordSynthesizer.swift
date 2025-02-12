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
        
    private let defaultVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-US")
        
    var didFinishSpeaking: (() -> Void)?
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }
    
    private func makeUtterance(with text: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = defaultVoice
        return utterance
    }
    
    func speak(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = makeUtterance(with: text)
        speechSynthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishSpeaking?()
    }
}
