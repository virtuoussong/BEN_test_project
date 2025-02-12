//
//  Ben_testTests.swift
//  Ben_testTests
//
//  Created by Chiman Song on 2/10/25.
//

import XCTest
@testable import Ben_test

final class WordGameViewModelTests: XCTestCase {
    
    func testCaptureWordFromSpeechListener() {
        let wordsArray = [["hello", "world"]]
        let mockSynth = MockSynthesizer()
        let mockSpeech = MockSpeechRecognizer()
        let viewModel = WordGameViewModel(synthesizer: mockSynth, listner: mockSpeech, words: wordsArray)
        
        mockSpeech.word = "hello"
        
        let expectation = XCTestExpectation(description: "Word captured")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(viewModel.capturedWords.contains(where: { $0.text.lowercased() == "hello" }),
                          "The capturedWords set should contain 'hello'")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandleTapWordCapturesCorrectly() {
        let wordsArray = [["tap", "skip"]]
        let mockSynth = MockSynthesizer()
        let mockSpeech = MockSpeechRecognizer()
        let viewModel = WordGameViewModel(synthesizer: mockSynth, listner: mockSpeech, words: wordsArray)
        
        if var firstWord = viewModel.words.first?.first {
            firstWord.isAnimating = true
            viewModel.words[0][0] = firstWord
            
            viewModel.handleTapWord(firstWord)
        }
        
        XCTAssertTrue(viewModel.capturedWords.contains(where: { $0.text.lowercased() == "tap" }), "The capturedWords set should contain 'tap'")
        XCTAssertEqual(mockSynth.spokenText?.lowercased(), "tap", "The synthesizer should speak 'tap'")
    }
    
    func testWordGameViewModelDeallocates() {
        weak var weakViewModel: WordGameViewModel?
        autoreleasepool {
            let wordsArray = [["test"]]
            let mockSynth = MockSynthesizer()
            let mockSpeech = MockSpeechRecognizer()
            let viewModel = WordGameViewModel(synthesizer: mockSynth, listner: mockSpeech, words: wordsArray)
            weakViewModel = viewModel
        }
        XCTAssertNil(weakViewModel, "WordGameViewModel should have been deallocated to avoid memory leaks")
    }
}
