//
//  File.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct CheckBoxView: View {
    @Binding var value: Bool
    var label: String
    var isEnabled: Bool

    var body: some View {
        Toggle(label, isOn: $value)
            .disabled(!isEnabled)
            .padding()
    }
}

