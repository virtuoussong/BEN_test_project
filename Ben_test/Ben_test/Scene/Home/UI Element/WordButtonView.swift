//
//  WordButtonView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordButtonView: View {
    let word: Word
    let tapAction: () -> Void
    
    var body: some View {
        Button(action: tapAction) {
            Text(word.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
        }
        .offset(x: word.offSetX, y: 0)
        .animation(.linear(duration: word.animationDuration), value: word.offSetX)
    }
}

#Preview {
    WordButtonView(word: Word(text: "hi"), tapAction: { })
}
