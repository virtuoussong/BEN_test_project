//
//  BottomActionButton.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import SwiftUI

struct BottomActionButton: View {
    @Binding var tap: (() -> Void)
    
    let title: String
    
    var font: Font = .system(size: 24, weight: .bold)
    var foregroundColor: Color = .white
    var backgroundColor: Color = .red
    var cornerRadioius: CGFloat = 20
    
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
    BottomActionButton(tap: .constant { print("buton tapped") }, title: "Start-Mock")
}
