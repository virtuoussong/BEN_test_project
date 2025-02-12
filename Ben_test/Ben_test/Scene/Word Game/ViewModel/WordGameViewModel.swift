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
    let speechListener: SpeechRecognizing
    
    private var cancellables = Set<AnyCancellable>()
    
    private var lastCapturedWord: String?

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
        bind()
    }
    
    func bind() {
        guard let speechListener = self.speechListener as? SpeechRecognizer else {
            return
        }
        
        speechListener.$word
            .compactMap { $0 }
            .sink { [weak self] recognizedWord in
                guard let self else { return }
                if let last = lastCapturedWord, last.lowercased() == recognizedWord.lowercased() {
                    return
                }
                
                captureWord(recognizedWord)
            }
            .store(in: &cancellables)
    }
    
    func findMatchingWord(for word: String) -> (sectionIndex: Int, wordIndex: Int)? {
        words.enumerated().compactMap { (sectionIndex, section) in
            section
                .firstIndex { $0.text.lowercased() == word.lowercased() }
                .map { (sectionIndex, $0) }
        }
        .first
    }
    
    func generateWords(section: [String]) -> [Word] {
        section.map { Word(text: $0, animationDuration: Double.random(in: 1...5)) }
    }
    
    func startAnimation() {
        guard activeSectionsCount == 0 else { return }
        
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
        if let wordIndex = words[section].firstIndex(where: { !$0.isHidden && !$0.isTapped && !$0.isAnimating } ) {
            let word = words[section][wordIndex]
            updateWordForAnimation(word: word, section: section, wordIndex: wordIndex)
            scheduleAnimationEnd(word: word, section: section)
        } else {
            handleSectionAnimationEnd()
        }
    }
    
    func updateWordForAnimation(word: Word, section: Int, wordIndex: Int) {
        var word = word
        word.isAnimating = true
        word.color = .blue
        
        withTransaction(Transaction(animation: nil)) {
            words[section][wordIndex] = word
        }
        
        words[section][wordIndex].offSetX = screenWidth - 150
    }
    
    func scheduleAnimationEnd(word: Word, section: Int) {
        let timer = Timer.scheduledTimer(withTimeInterval: word.animationDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            finishWordAnimation(word: word, section: section)
            animateWord(section)
        }
        
        animationTimers[word.id] = timer
    }
    
    func finishWordAnimation(word: Word, section: Int) {
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
    
    func handleTapWord(_ tappedWord: Word) {
        guard tappedWord.isAnimating else { return }
        
        if let timer = animationTimers[tappedWord.id] {
            timer.invalidate()
            animationTimers.removeValue(forKey: tappedWord.id)
        }
        
        captureWord(tappedWord.text)
    }
    
    func captureWord(_ wordText: String) {
        if let (sectionIndex, wordIndex) = findMatchingWord(for: wordText) {
            var captured = words[sectionIndex][wordIndex]
            captured.isHidden = true
            captured.isTapped = true
            
            words[sectionIndex][wordIndex] = captured
            
            capturedWords.insert(captured)
            
            speakWord(wordText)
            
            lastCapturedWord = wordText
            
            animateWord(sectionIndex)
        }
    }
    
    func handleSectionAnimationEnd() {
        activeSectionsCount -= 1
        if activeSectionsCount <= 0 {
            stopListening()
        }
    }
    
    func speakWord(_ text: String) {
        stopListening()
        
        synthesizer.didFinishSpeaking = { [weak self] in
            self?.startListening()
        }
        
        synthesizer.speak(text)
    }
    
    func startListening() {
        speechListener.startListening()
    }
        
    func stopListening() {
        speechListener.stopListening()
    }
    
    func setScreenWidth(_ width: CGFloat) {
        self.screenWidth = width
    }
}
