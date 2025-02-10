//
//  WordGameViewModel.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import SwiftUI

final class WordGameViewModel: ObservableObject {
    @Published var words: String = ""
    
    let wordsArray: [String]
    
    init(words: [String]) {
        self.wordsArray = words
    }
    
    func startAnimation() {
        
    }
    
    func resetAnumation() {
        
    }
    
    func handleTapWord() {
        
    }
    
    func speakWord() {
        
    }
}
