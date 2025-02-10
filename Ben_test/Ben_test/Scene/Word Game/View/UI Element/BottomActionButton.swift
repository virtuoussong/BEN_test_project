//
//  BottomActionButton.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct BottomActionButton: View {
    let title: String
    
    var font: Font = .system(size: 24, weight: .bold)
    var foregroundColor: Color = .white
    var backgroundColor: Color = .red
    var cornerRadioius: CGFloat = 20
    
    let tap: (() -> Void)
    
    var body: some View {
        Button(title) {
            tap()
        }
        .padding()
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .font(font)
        .cornerRadius(cornerRadioius)
    }
    
}

#Preview {
    BottomActionButton(title: "Start-Mock", tap: { print("buton tapped") })
}
