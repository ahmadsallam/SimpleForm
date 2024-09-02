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
    let additionalViews: [AnyView]
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    

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
                        isEnabled: $formModel.isOn
                    )
                    .applyDisabledStyle(isEnabled: formModel.isOn)

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
                    CheckBoxView(value: $formModel.isOn, label: field.label, isEnabled: field.enabled ?? true)
                    
                case .image:
                    Image(field.value.value as? String ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    
                    
                case .date:
                    DatePicker(
                        "Date",
                        selection: $selectedDate,
                        in: ...Date(), // Limits selection to past dates
                        displayedComponents: [.date] // Displays both date and time
                    )
                    .padding()

                case .time:
                    DatePicker(
                        "Time",
                        selection: $selectedTime,
                        displayedComponents: [.hourAndMinute] // Show only time
                    )
                    .datePickerStyle(WheelDatePickerStyle()) // Use a wheel style for time picker
                    .padding(EdgeInsets())
                case .file:
                   EmptyView()
                case .custom:
                   EmptyView()
                }
            }
            
            ForEach(0..<additionalViews.count, id: \.self) { index in
                additionalViews[index]
            }
            
            Button("Submit") {
                if formModel.validate() {
                    print("Form is valid, proceed with submission")
                } else {
                    print("Form is invalid, please correct the errors")
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
        }
    }
}
