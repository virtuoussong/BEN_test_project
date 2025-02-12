//
//  WordGameViewModel.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import SwiftUI
import Combine

final class WordGameViewModel: ObservableObject {
    @Published var words: [[Word]] = []
    @Published var finishedWords: [[Word]] = []
    @Published var capturedWords: Set<Word> = []
    
    private var animationTimers: [UUID: Timer] = [:]
    private var activeSectionsCount: Int = 0
    
    let wordsArray: [[String]]
    var screenWidth: CGFloat = 0
    
    let synthesizer: WordSynthesizing
    let speechListener: SpeechRecognizer
    
    private var cancellables = Set<AnyCancellable>()
    
    private var lastCapturedWord: String?

    init(
        synthesizer: WordSynthesizing = WordSynthesizer(),
        listner: SpeechRecognizer = SpeechRecognizer(),
        words: [[String]]
    ) {
        self.synthesizer = synthesizer
        self.speechListener = listner
        self.wordsArray = words
        self.words = words.map(generateWords)
        self.finishedWords = Array(repeating: [], count: words.count)
        bind()
    }
    
    func bind() {
        speechListener.$word
            .compactMap { $0 }
            .sink { [weak self] recognizedWord in
                guard let self else { return }
                if let last = self.lastCapturedWord, last.lowercased() == recognizedWord.lowercased() {
                    return
                }
                
                if let (sectionIndex, wordIndex) = self.words
                    .enumerated()
                    .compactMap({ sectionIndex, section in
                        section.firstIndex(where: { $0.text.lowercased() == recognizedWord.lowercased() })
                        .map { (sectionIndex, $0) }
                    })
                    .first {
                        let matchedWord = self.words[sectionIndex][wordIndex]
                        self.handleTapWord(matchedWord)
                    }
            }
            .store(in: &cancellables)
    }
    
    func generateWords(section: [String]) -> [Word] {
        section.map { Word(text: $0, animationDuration: Double.random(in: 1...5)) }
    }
    
    func startAnimation() {
        activeSectionsCount = 0
        startListening()
        
        for section in words.indices {
            if words[section].contains(where: { !$0.isHidden && !$0.isTapped }) {
                activeSectionsCount += 1
                animateWord(section)
            }
        }
    }
    
    func animateWord(_ section: Int) {
        if let wordIndex = words[section].firstIndex(
            where: { !$0.isHidden && !$0.isTapped && !$0.isAnimating }
        ) {
            var word = words[section][wordIndex]
            word.isAnimating = true
            word.color = .blue
            
            withTransaction(Transaction(animation: nil)) {
                words[section][wordIndex] = word
            }
            
            words[section][wordIndex].offSetX = screenWidth - 150
            
            let timer = Timer.scheduledTimer(withTimeInterval: word.animationDuration, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                
                if let currentIndex = self.words[section].firstIndex(where: { $0.id == word.id }) {
                    var finishedWord = self.words[section][currentIndex]

                    if !finishedWord.isTapped {
                        finishedWord.isHidden = true
                        finishedWord.isAnimating = false
                        self.finishedWords[section].append(finishedWord)
                        self.words[section][currentIndex] = finishedWord
                    }
                }

                self.animateWord(section)
            }
            
            animationTimers[word.id] = timer
            
        } else {
            activeSectionsCount -= 1
            
            if activeSectionsCount <= 0 {
                stopListening()
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
        capturedWords.removeAll()
        words = wordsArray.map(generateWords)
    }
    
    func handleTapWord(_ tappedWord: Word) {
        guard tappedWord.isAnimating else { return }
        
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
                
                capturedWords.insert(captured)
                speakWord(tappedWord.text)
                lastCapturedWord = tappedWord.text
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
    
    func startListening() {
        speechListener.startListening()
    }
        
    func stopListening() {
        speechListener.stopListening()
    }
}
