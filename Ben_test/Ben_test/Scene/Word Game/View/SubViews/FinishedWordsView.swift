//
//  FinishedWordsView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct FinishedWordsView: View {
    
    @Binding var finishedWords: [[Word]]
    
    var body: some View {
        VStack {
            ForEach($finishedWords, id: \.self) { section in
                VStack(alignment: .trailing) {
                    ForEach(section, id: \.self) { $word in
                        Text(word.text)
                            .font(Font.system(size: 12, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom, 24)
                
            }
        }
    }
}

#Preview {
    FinishedWordsView(finishedWords: .constant([]))
}
