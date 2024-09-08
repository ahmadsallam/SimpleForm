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
    var isEnabled: Bool

    var body: some View {
        TextField(label, text: $value)
            .keyboardType(.numberPad)
            .disabled(!isEnabled)
            .padding()
    }
}


