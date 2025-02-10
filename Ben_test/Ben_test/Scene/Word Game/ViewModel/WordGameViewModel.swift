//
//  WordGameViewModel.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import SwiftUI

final class WordGameViewModel: ObservableObject {
    @Published var words: [[Word]] = []
    let synthesizer: WordSynthesizing
    let wordsArray: [[String]]
    
    init(
        synthesizer: WordSynthesizing = WordSynthesizer(),
        words: [[String]]
    ) {
        self.synthesizer = synthesizer
        self.wordsArray = words
        self.words = words.map(generateWords)
    }
    
    func generateWords(section: [String]) -> [Word] {
        section.map { Word(text: $0, animationDuration: Double.random(in: 3...10)) }
    }
    
    func startAnimation() {
        print("start animation")
    }
    
    func resetAnimation() {
        print("reset animation")
    }
    
    func handleTapWord(_ word: Word) {
        print(word.text)
        speakWord(word.text)
    }
    
    func speakWord(_ text: String) {
        synthesizer.speak(text)
    }
}
