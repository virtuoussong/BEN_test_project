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
        VStack {
            ForEach(viewModel.words, id: \.self) { section in
                VStack {
                    ForEach(section, id: \.self) { word in
                        WordButtonView(word: word) {
                            viewModel.handleTapWord(word)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    let mockViewModel = WordGameViewModel(words: FruitsData.fruits)
        
    return WordListView()
        .environmentObject(mockViewModel)
}
