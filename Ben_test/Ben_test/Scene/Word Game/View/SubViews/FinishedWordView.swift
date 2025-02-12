//
//  FinishedWordView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/12/25.
//

import SwiftUI

struct FinishedWordView: View {
    @Binding var word: Word
    
    var body: some View {
        Text(word.text)
            .font(Font.system(size: 12, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
    }
}

#Preview {
    FinishedWordView(word: .constant( Word(text: "asf")))
}
