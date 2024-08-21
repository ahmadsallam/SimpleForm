//
//  FormView.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct FormView: View {
    @ObservedObject var formModel: FormModel

    var body: some View {
        Form {
            ForEach($formModel.fields) { $field in
                switch field.type {
                case .text:
                    TextFieldView(
                        value: Binding(
                            get: { field.value.value as? String ?? "" },
                            set: { newValue in field.setNewValue(newValue: AnyCodable(newValue)) }
                        ),
                        label: field.label,
                        isEnabled: Binding(
                            get: { field.enabled ?? false },
                            set: { newValue in field.enable(newValue: newValue) }
                        )
                    )
                case .number:
                    NumberFieldView(value: Binding(
                        get: { field.value.value as? String ?? "" },
                        set: { newValue in field.setNewValue(newValue: AnyCodable(newValue)) }
                    ), label: field.label, isEnabled: field.enabled ?? true)
                case .dropdown:
                    DropdownFieldView(value: Binding(
                        get: { field.value.value as? String ?? "" },
                        set: { newValue in field.setNewValue(newValue: AnyCodable(newValue)) }
                    ), label: field.label, options: field.options ?? [], isEnabled: field.enabled ?? true)
                case .checkbox:
                    CheckBoxView(value: Binding(
                        get: { field.value.value as? Bool ?? false },
                        set: { newValue in field.setNewValue(newValue: AnyCodable(newValue)) }
                    ), label: field.label, isEnabled: field.enabled ?? true)
                }
            }
            Button("Submit") {
                if formModel.validate() {
                    print("Form is valid, proceed with submission")
                } else {
                    print("Form is invalid, please correct the errors")
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
