//
//  File.swift
//  
//
//  Created by Ahmad on 28/08/2024.
//

import Foundation
import SwiftUI

public extension View {
    func applyOutlinedStyle(isEnabled: Bool, isValid: Bool) -> some View {
        self.modifier(OutlinedStyle(isEnabled: isEnabled, isValid: isValid))
    }
}

struct OutlinedStyle: ViewModifier {
    var isEnabled: Bool
    var isValid: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(isEnabled ? .primary : .gray) // Adjust text color
            .opacity(isEnabled ? 1.0 : 0.6) // Adjust opacity
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke( isValid ? (isEnabled ? .blue : Color(UIColor.lightGray)) : .red, lineWidth: 1) // Adjust border color
            )
    }
}
