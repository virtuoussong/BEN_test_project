//
//  WordListView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordListView: View {
    @EnvironmentObject var viewModel: WordGameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    ForEach(viewModel.words.indices, id: \.self) { sectionIndex in
                        WordSectionView(
                            words: $viewModel.words[sectionIndex],
                            finishedWords: $viewModel.finishedWords[sectionIndex]
                        ) { word in
                            viewModel.handleTapWord(word)
                        }
                    }
                }
                .onAppear {
                    viewModel.setScreenWidth(geometry.size.width)
                }
            }
        }
    }
}

#Preview {
    let mockViewModel = WordGameViewModel(words: FruitsData.fruits)
        
    return WordListView()
        .environmentObject(mockViewModel)
}
