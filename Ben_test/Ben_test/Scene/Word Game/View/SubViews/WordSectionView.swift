//
//  WordSectionView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/12/25.
//

import SwiftUI

struct WordSectionView: View {
    @EnvironmentObject var viewModel: WordGameViewModel
    
    let sectionIndex: Int
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach($viewModel.words[sectionIndex]) { $word in
                    WordButtonView(word: $word) {
                        viewModel.handleTapWord(word)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets())
                }
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                ForEach($viewModel.finishedWords[sectionIndex]) { $word in
                    FinishedWordView(word: $word)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.finishedWords[sectionIndex])
    }
}

#Preview {
    WordSectionView(sectionIndex: 0)
        .environmentObject(WordGameViewModel(words: [["a", "b"], ["c", "d"]]))
}
