//
//  MockSpeechRecognizer.swift
//  Ben_testTests
//
//  Created by Chiman Song on 2/12/25.
//

@testable import Ben_test
import Combine

final class MockSpeechRecognizer: SpeechRecognizing {
    @Published var word: String?
    
    var wordPublisher: AnyPublisher<String?, Never> {
        $word.eraseToAnyPublisher()
    }
    var startListeningCalled = false
    var stopListeningCalled = false
    
    func startListening() {
        startListeningCalled = true
    }
    
    func stopListening() {
        stopListeningCalled = true
    }
}
