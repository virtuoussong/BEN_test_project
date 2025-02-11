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
            WordListView()
            
            WordScapeCapuredListView(words: $viewModel.capturedWords)
                .frame(alignment: .topLeading)
            
            WordGameBottomButtonView()
                
        }
        .padding(.horizontal, 8)
        .environmentObject(viewModel)
    }
}

#Preview {
    WordGameView()
}

