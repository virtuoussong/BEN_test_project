//
//  WordSectionView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/12/25.
//

import SwiftUI

struct WordSectionView: View {
    @Binding var words: [Word]
    @Binding var finishedWords: [Word]
    var tap: (Word) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach($words) { $word in
                    WordButtonView(word: $word) {
                        tap(word)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets())
                }
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                ForEach($finishedWords) { $word in
                    FinishedWordView(word: $word)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: finishedWords)
    }
}

#Preview {
    WordSectionView(words: .constant([]), finishedWords: .constant([]), tap: { _ in })
}
