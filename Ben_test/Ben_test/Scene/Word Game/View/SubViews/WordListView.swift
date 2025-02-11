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
            VStack(spacing: 24) {
                ForEach(viewModel.words.indices, id: \.self) { sectionIndex in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach($viewModel.words[sectionIndex]) { $word in
                                WordButtonView(word: $word) {
                                    viewModel.handleTapWord(word)
                                }
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .listRowInsets(EdgeInsets())
                            }
                        }
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            ForEach($viewModel.finishedWords[sectionIndex]) { $word in
                                Text(word.text)
                                    .font(Font.system(size: 12, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.setScreenWidth(geometry.size.width)
            }
        }
    }
}

#Preview {
    let mockViewModel = WordGameViewModel(words: FruitsData.fruits)
        
    return WordListView()
        .environmentObject(mockViewModel)
}
