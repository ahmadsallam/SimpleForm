//
//  File.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct DropdownFieldView: View {
    @Binding var selectedOption: String
    var label: String
    var options: [String]
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    @State var isValid = true
    
    var body: some View {
        if !isHidden {
            VStack {
                HStack {
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectedOption = option
                            }) {
                                Text(option)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedOption)
                                .foregroundColor(selectedOption.isEmpty ? .gray : .primary)
                                .padding()
                            
                            Spacer() // Push text to the left
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .disabled(!isEnabled)
                    .applyOutlinedStyle(isEnabled: isEnabled, isValid: true)
                }
                if !isValid {
                    ErrorMessageView(message: "error")
                }
            }
        }
    }
}
