//
//  File.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct NumberFieldView: View {
    @Binding var value: String
    var label: String
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    var isValid: Bool
    var errorMessage: String
    
    var onChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            TextField(label, text: $value)
                .keyboardType(.numberPad)
                .disabled(!isEnabled)
                .padding()
                .applyOutlinedStyle(isEnabled: isEnabled, isValid: isValid)
                .onChange(of: value, perform: { value in
                    onChange()
                })
            
            if !isValid {
                ErrorMessageView(message: errorMessage)
            }
        })
    }
}


