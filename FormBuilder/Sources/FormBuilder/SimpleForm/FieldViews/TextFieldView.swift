//
//  Text.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct TextFieldView: View {
    @Binding var value: String
    var label: String
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    var isValid: Bool
    var errorMessage: String
    
    var keyboardType: String
    
    var body: some View {
        if !isHidden {
            VStack(alignment: .leading, spacing: 8, content: {
                TextField(label, text: $value)
                    .keyboardType(keyboardType == "Number" ? .numberPad : .default)
                    .disabled(!isEnabled)
                    .padding()
                    .applyOutlinedStyle(isEnabled: isEnabled, isValid: isValid)
                
                if !isValid {
                    ErrorMessageView(message: "This field is required.")
                }
            })
        }
    }
}
