//
//  File.swift
//  
//
//  Created by Ahmad on 28/08/2024.
//

import Foundation
import SwiftUI

public extension View {
    func applyDisabledStyle(isEnabled: Bool) -> some View {
        self.modifier(DisabledStyle(isEnabled: isEnabled))
    }
}

struct DisabledStyle: ViewModifier {
    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(isEnabled ? .primary : .gray) // Adjust text color
            .opacity(isEnabled ? 1.0 : 0.6) // Adjust opacity
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? Color.blue : Color.gray, lineWidth: 1) // Adjust border color
            )
    }
}
