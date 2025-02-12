//
//  MockSynthesizer.swift
//  Ben_testTests
//
//  Created by Chiman Song on 2/12/25.
//

@testable import Ben_test

final class MockSynthesizer: WordSynthesizing {
    var didFinishSpeaking: (() -> Void)?
    var spokenText: String?
    
    func speak(_ text: String) {
        spokenText = text
        didFinishSpeaking?()
    }
}
