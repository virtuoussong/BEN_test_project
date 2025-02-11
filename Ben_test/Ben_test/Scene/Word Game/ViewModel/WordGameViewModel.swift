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
    @Published var finishedWords: [[Word]] = []
    @Published var capturedWords: [Word] = []
    private var animationTimers: [UUID: Timer] = [:]
    
    let synthesizer: WordSynthesizing
    let wordsArray: [[String]]
    var screenWidth: CGFloat = 0
    
    init(
        synthesizer: WordSynthesizing = WordSynthesizer(),
        words: [[String]]
    ) {
        self.synthesizer = synthesizer
        self.wordsArray = words
        self.words = words.map(generateWords)
        self.finishedWords = Array(repeating: [], count: words.count)
    }
    
    func generateWords(section: [String]) -> [Word] {
        section.map { Word(text: $0, animationDuration: Double.random(in: 1...5)) }
    }
    
    func startAnimation() {
        for sectionIndex in words.indices {
            for wordIndex in words[sectionIndex].indices {
                var word = words[sectionIndex][wordIndex]
                
                withTransaction(Transaction(animation: nil)) {
                    word.color = .blue
                    words[sectionIndex][wordIndex] = word
                }
                
                word.offSetX = screenWidth - 150
                words[sectionIndex][wordIndex] = word
                
                let timer = Timer.scheduledTimer(withTimeInterval: word.animationDuration, repeats: false) { [weak self] _ in
                    guard let self else { return }

                    if let currentIndex = self.words[sectionIndex].firstIndex(where: { $0.id == word.id }) {
                        let finishedWord = self.words[sectionIndex][currentIndex]
                        
                        if !finishedWord.isTapped {
                            finishedWords[sectionIndex].append(finishedWord)
                            self.words[sectionIndex][currentIndex].isHidden = true
                        }
                    }
                }
                
                animationTimers[word.id] = timer
            }
        }
    }
    
    func resetAnimation() {
        for timer in animationTimers.values {
            timer.invalidate()
        }
        
        animationTimers.removeAll()
        finishedWords.removeAll()
        finishedWords = Array(repeating: [], count: words.count)
        words = wordsArray.map(generateWords)
    }
    
    func handleTapWord(_ tappedWord: Word) {
        if let timer = animationTimers[tappedWord.id] {
            timer.invalidate()
            animationTimers.removeValue(forKey: tappedWord.id)
        }

        for sectionIndex in words.indices {
            if let index = words[sectionIndex].firstIndex(where: { $0.id == tappedWord.id }) {
                var captured = words[sectionIndex][index]
                captured.isHidden = true
                captured.isTapped = true
                
                words[sectionIndex][index] = captured
                
                capturedWords.append(captured)
                speakWord(tappedWord.text)
                return
            }
        }
        
        speakWord(tappedWord.text)
    }
    
    func speakWord(_ text: String) {
        synthesizer.speak(text)
    }
    
    func setScreenWidth(_ width: CGFloat) {
        self.screenWidth = width
    }
}
