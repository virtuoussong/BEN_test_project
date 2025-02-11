//
//  WordScapeCapuredListView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/11/25.
//

import SwiftUI

struct WordScapeCapuredListView: View {
    
    @Binding var words: [Word]
    
    var body: some View {
        Text(words.map{ $0.text }.joined(separator: ", "))
            .font(.system(size: 16, weight: .regular))
    }
}

#Preview {
    WordScapeCapuredListView(words: .constant([]))
}
