//
//  WordGameBottomButtonView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordGameBottomButtonView: View {
    @EnvironmentObject var viewModel: WordGameViewModel
    
    var body: some View {
        HStack {
            BottomButtomView(text: "Start", tap: viewModel.startAnimation)
            
            Spacer()
                .frame(width: 16)
            
            BottomButtomView(text: "Reset", tap: viewModel.resetAnimation)
        }
    }
}

#Preview {
    WordGameBottomButtonView()
        .environmentObject(WordGameViewModel(words: [["a", "b"], ["c", "d"]]))
}
