//
//  Word.swift
//  Ben_test
//
//  Created by Chiman Song on 2/10/25.
//

import Foundation
import SwiftUI

struct Word: Identifiable, Hashable {
    let id = UUID()
    let text: String
    var offSetX: CGFloat = 0
    var animationDuration: Double = 0
    var color: Color = .orange
    var isHidden = false
    var isTapped = false
    var isAnimating = false
}
