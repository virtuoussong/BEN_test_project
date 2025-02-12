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
    
    // MARK: - Published Properties

    @Published var words: [[Word]] = []
    @Published var finishedWords: [[Word]] = []
    @Published var capturedWords: Set<Word> = []
    
    // MARK: - Dependencies & State
    
    private let wordsArray: [[String]]
    private(set) var screenWidth: CGFloat = 0
    private let synthesizer: WordSynthesizing
    private let speechListener: SpeechRecognizing
    private var cancellables = Set<AnyCancellable>()
    
    // Timer management for animation.
    private var animationTimers: [UUID: Timer] = [:]
    
    // How many sections are still running animations.
    private var activeSectionsCount: Int = 0
    
    // Used to avoid processing the same recognized word repeatedly.
    private var lastCapturedWord: String?

    // MARK: - Initializer

    init(
        synthesizer: WordSynthesizing = WordSynthesizer(),
        listner: SpeechRecognizing = SpeechRecognizer(),
        words: [[String]]
    ) {
        self.synthesizer = synthesizer
        self.speechListener = listner
        self.wordsArray = words
        self.words = words.map(generateWords)
        self.finishedWords = Array(repeating: [], count: words.count)
        bindSpeechListener()
    }
    
    // MARK: - Binding
    
    private func bindSpeechListener() {
        speechListener.wordPublisher
            .compactMap { $0 }
            .sink { [weak self] recognizedWord in
                guard let self,
                      !isDuplicate(recognizedWord) else { return }
                
                captureWord(for: recognizedWord)
            }
            .store(in: &cancellables)
    }
        
    private func isDuplicate(_ recognizedWord: String) -> Bool {
        if let last = lastCapturedWord, last.lowercased() == recognizedWord.lowercased() {
            return true
        }
        return false
    }
    
    // MARK: - Word Generation

    private func generateWords(section: [String]) -> [Word] {
        section.map { Word(text: $0, animationDuration: Double.random(in: 1...5)) }
    }
    
    // MARK: - Animation Control

    func startAnimation() {
        guard activeSectionsCount == 0 else { return }
        
        activeSectionsCount = 0
        startListening()
        
        for section in words.indices {
            if words[section].contains(where: { !$0.isHidden && !$0.isTapped }) {
                activeSectionsCount += 1
                animateNextWord(in: section)
            }
        }
    }
    
    private func animateNextWord(in section: Int) {
        if let wordIndex = words[section].firstIndex(where: { !$0.isHidden && !$0.isTapped && !$0.isAnimating } ) {
            let word = words[section][wordIndex]
            prepareWordForAnimation(word: word, section: section, wordIndex: wordIndex)
            scheduleAnimationEnd(word: word, section: section)
        } else {
            completeSectionAnimation()
        }
    }
    
    private func prepareWordForAnimation(word: Word, section: Int, wordIndex: Int) {
        var word = word
        word.isAnimating = true
        word.color = .blue
        
        withTransaction(Transaction(animation: nil)) {
            words[section][wordIndex] = word
        }
        
        words[section][wordIndex].offSetX = screenWidth - 150
    }
    
    private func scheduleAnimationEnd(word: Word, section: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: word.animationDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            finishAnimation(for: word, in: section)
            
            DispatchQueue.main.async {
                self.animateNextWord(in: section)
            }
        }
        
        animationTimers[word.id] = timer
    }
    
    private func finishAnimation(for word: Word, in section: Int) {
        if let currentIndex = words[section].firstIndex(where: { $0.id == word.id }) {
            var finishedWord = words[section][currentIndex]

            if !finishedWord.isTapped {
                finishedWord.isHidden = true
                finishedWord.isAnimating = false
                
                finishedWords[section].append(finishedWord)
                words[section][currentIndex] = finishedWord
            }
        }
    }
    
    private func completeSectionAnimation() {
        activeSectionsCount -= 1
        if activeSectionsCount <= 0 {
            stopListening()
        }
    }
    
    // MARK: - Word Capturing
    
    private func captureWord(for recognizedWord: String) {
        if let (sectionIndex, wordIndex) = findMatchingWord(for: recognizedWord) {
            var captured = words[sectionIndex][wordIndex]
            captured.isHidden = true
            captured.isTapped = true
            
            words[sectionIndex][wordIndex] = captured
            
            capturedWords.insert(captured)
            
            lastCapturedWord = recognizedWord
            
            self.speakWord(recognizedWord)
            
            DispatchQueue.main.async{
                self.animateNextWord(in: sectionIndex)
            }
        }
    }
    
    private func findMatchingWord(for word: String) -> (sectionIndex: Int, wordIndex: Int)? {
        words.enumerated().compactMap { (sectionIndex, section) in
            section
                .firstIndex { $0.text.lowercased() == word.lowercased() }
                .map { (sectionIndex, $0) }
        }
        .first
    }
    
    func handleTapWord(_ tappedWord: Word) {
        guard tappedWord.isAnimating else { return }
        
        if let timer = animationTimers[tappedWord.id] {
            timer.invalidate()
            animationTimers.removeValue(forKey: tappedWord.id)
        }
        
        captureWord(for: tappedWord.text)
    }
    
    // MARK: - Speech & Synthesis
    
    private func speakWord(_ text: String) {
        stopListening()
        
        synthesizer.didFinishSpeaking = { [weak self] in
            self?.startListening()
        }
        
        self.synthesizer.speak(text)
    }
    
    // MARK: - Listening Control
    
    private func startListening() {
        speechListener.startListening()
    }
        
    private func stopListening() {
        speechListener.stopListening()
    }
    
    // MARK: - Utilities
    
    func setScreenWidth(_ width: CGFloat) {
        self.screenWidth = width
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
        activeSectionsCount = 0
    }
}
