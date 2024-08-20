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

    var body: some View {
        TextField(label, text: $value)
            .disabled(!isEnabled)
            .padding()
    }
}
