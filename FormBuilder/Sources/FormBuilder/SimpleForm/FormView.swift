//
//  FormView.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

public protocol CustomViewRepresentable {
    func getCustomView(type: String) -> AnyView
}

struct FormView: View {
    @ObservedObject var formModel: FormModel
    let additionalViews: [AnyView]
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
    var delegate: CustomViewRepresentable?
    
    var body: some View {
        Form {
            ForEach($formModel.fields, id: \.id) { $field in
                
                switch field.type {
                case .text:
                    TextFieldView(
                        value: Binding(
                            get: { ((field.value?.value ?? "") as? String) ?? "" },
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.applyBusinessRules() } ),
                        label: field.label ?? "",
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)})
                    )
                    .applyDisabledStyle(isEnabled: field.enabled ?? true)
                    
                case .number:
                    NumberFieldView(
                        value: Binding(
                            get: { field.value?.value as? String ?? "" },
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.applyBusinessRules()
                            }
                        ), label: field.label ?? "", isEnabled: field.enabled ?? true)
                    .applyDisabledStyle(isEnabled: true)
                    
                case .dropdown:
                    DropdownFieldView(
                        value: Binding(
                            get: { field.value?.value as? String ?? field.options?.first ?? "" },
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.applyBusinessRules() }),
                        label: field.label ?? "", 
                        options: field.options ?? [],
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}))
                    .applyDisabledStyle(isEnabled: field.enabled ?? true)
                    
                case .checkbox:
                    CheckBoxView(value: $formModel.isOn, label: field.label ?? "", isEnabled: field.enabled ?? true)
                    
                case .image:
                    Image(field.value?.value as? String ?? "")
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
                    if let delegate = self.delegate {
                        let view = delegate.getCustomView(type: field.customType ?? "")
                        AnyView(view)
                    } else {
                        EmptyView()
                    }
                    
                case .multiSelection:
                    MultiSelectView()
                        .frame(height: 300)
                case .unknown, .none:
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
