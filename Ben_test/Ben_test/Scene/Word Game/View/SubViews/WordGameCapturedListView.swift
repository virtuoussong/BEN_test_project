//
//  WordGameCapturedListView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct WordGameCapturedListView: View {
    @Binding var words: [Word]
    
    var body: some View {
        HStack {
            ForEach(words) { item in
                Text(item.text)
            }
        }
    }
}

#Preview {
    WordGameCapturedListView(words: .constant([Word(text: "test"), Word(text: "test2")]))
}
