//
//  BottomButtonView.swift
//  Ben_test
//
//  Created by Chiman Song on 2/12/25.
//

import SwiftUI

struct BottomButtomView: View {
    let text: String
    let tap: () -> Void
    
    var body: some View {
        Button(action: {
            tap()
        }) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(8)
    }
}

#Preview {
    BottomButtomView(text: "asdf", tap: {})
}
