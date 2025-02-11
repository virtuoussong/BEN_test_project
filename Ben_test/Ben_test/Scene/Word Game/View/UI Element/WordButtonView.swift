//
//  WordButtonView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordButtonView: View {
    @Binding var word: Word
    let tapAction: () -> Void
    
    var body: some View {
        Button(action: tapAction) {
            Text(word.text)
                .font(Font.system(size: 12, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(word.color)
                .cornerRadius(8)
        }
        .offset(x: word.offSetX, y: 0)
        .animation(.linear(duration: word.animationDuration), value: word.offSetX)
        .opacity(word.isHidden ? 0 : 1)
        .allowsHitTesting(!word.isHidden)
    }
}

#Preview {
    WordButtonView(word: .constant(Word(text: "hi")), tapAction: { })
}
