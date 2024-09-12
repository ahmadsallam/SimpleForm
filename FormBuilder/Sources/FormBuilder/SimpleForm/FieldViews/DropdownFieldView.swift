//
//  File.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct DropdownFieldView: View {
    @Binding var value: String
    var label: String
    var options: [String]
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    
    var body: some View {
        if !isHidden {
            Picker(label, selection: $value) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .disabled(!isEnabled)
            .padding()
        }
    }
}
