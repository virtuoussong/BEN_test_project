//
//  Home.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordGameView: View {
    @StateObject private var viewModel: WordGameViewModel
    
    init() {
        let vm = WordGameViewModel(words: FruitsData.fruits)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack() {
            HStack {
                WordListView()
            }
            .padding(.horizontal, 8)
            
            Spacer()
            WordGameBottomButtonView()
                .padding(.horizontal, 16)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    WordGameView()
}

