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
            Button(action: {
                viewModel.startAnimation()
            }) {
                Text("Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
            
            Spacer()
                .frame(width: 16)
            
            Button(action: {
                viewModel.resetAnimation()
            }) {
                Text("Reset")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
}

#Preview {
    WordGameBottomButtonView()
}
