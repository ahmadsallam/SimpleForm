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
                                formModel.applyBusinessRules() }),
                        label: field.label ?? "",
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}),
                        isValid: field.isValid ?? true,
                        errorMessage: field.errorMessage ?? "",
                        keyboardType: field.style?.keyboardType ?? "",
                        onChange: {
                            let validation = RuleValidator.validate(field: field)
                            field.isValid(validation.isValid)
                        }
                    )

                case .number:
                    NumberFieldView(
                        value: Binding(
                            get: { field.value?.value as? String ?? "" },
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.applyBusinessRules()
                            }
                        ),
                        label: field.label ?? "",
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}),
                        isValid: field.isValid ?? true,
                        errorMessage: field.errorMessage ?? "",
                        onChange: {
                            let validation = RuleValidator.validate(field: field)
                            field.isValid(validation.isValid)
                        })
                    
                case .dropdown:
                    DropdownFieldView(
                        selectedOption: Binding(
                            get: { field.value?.value as? String ?? (field.dropDownLabel ?? "")},
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.resetDependentChileds(filedId: field.fieldID ?? "")
                                formModel.applyBusinessRules()
                            }),
                        label: field.dropDownLabel ?? "",
                        options: field.options ?? [],
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}))
                case .checkbox:
                    CheckBoxView(isSelected: Binding(get: {field.isSelected ?? false},
                                                     set: { newValue in field.selected(newValue)}),
                                 isEnabled: Binding(get: {field.enabled ?? true},
                                                    set: { newValue in field.enable(newValue: newValue)}),
                                 isHidden: Binding(get: {field.isHidden ?? false},
                                                   set: { newValue in field.hide(newValue: newValue)}),
                                 item: field.label ?? "")
                    
                case .image:
                    EmptyView()
//                    AttachmentUploadView()
                case .date:
                    DateFieldView(
                        selectedDate: Binding(get: {(field.value?.value as? Date) ?? Date()},
                                              set: { newValue in
                                                  field.setNewValue(newValue: AnyCodable(newValue))
                                                  formModel.applyBusinessRules() }),
                        label: field.label ?? "",
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}),
                        isValid: field.isValid ?? true,
                        errorMessage: field.errorMessage ?? "")
                    
                    
                case .time:
                                        
                    DatePicker(
                        "Time",
                        selection: $selectedTime,
                        displayedComponents: [.hourAndMinute] // Show only time
                    )
                    .padding(EdgeInsets())
                case .file:
                    EmptyView()
                case .custom:
                    if let delegate = self.delegate, !(field.isHidden ?? true ) {
                        let view = delegate.getCustomView(type: field.customType ?? "")
                        
                        AnyView(view)
                        
                    } else {
                        EmptyView()
                    }
                    
                case .multiSelection:
                    MultiSelectView(selectedOption: Binding(
                        get: { field.value?.value as? String ?? (field.label ?? "") },
                        set: { newValue in
                            field.setNewValue(newValue: AnyCodable(newValue))
                            formModel.applyBusinessRules() }),
                                    label: field.label ?? "",
                                    options: field.options ?? [],
                                    isEnabled: Binding(get: {field.enabled ?? true},
                                                       set: { newValue in field.enable(newValue: newValue)}),
                                    isHidden: Binding(get: {field.isHidden ?? false},
                                                      set: { newValue in field.hide(newValue: newValue)}))
                    
                case .radio:
                    SingleSelectionView(
                        selectedOption: Binding(get: { field.value?.value as? String ?? (field.dropDownLabel ?? "") },
                                                 set: { newValue in
                                                     field.setNewValue(newValue: AnyCodable(newValue))
                                                     formModel.applyBusinessRules() }),
                        label: field.label ?? "",
                        options: field.options ?? [],
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}))
                    
                case .switch:
                    SwitchView(
                        label: field.label ?? "",
                        options: field.options ?? [],
                        isEnabled: Binding(get: {field.enabled ?? true},
                                           set: { newValue in field.enable(newValue: newValue)}),
                        isHidden: Binding(get: {field.isHidden ?? false},
                                          set: { newValue in field.hide(newValue: newValue)}))
                    
                case .unknown, .none:
                    EmptyView()
                }
            }
            
            ForEach(0..<additionalViews.count, id: \.self) { index in
                additionalViews[index]
            }
            
            Button("Submit") {
//                if formModel.validate() {
//                    print("Form is valid, proceed with submission")
//                } else {
//                    print("Form is invalid, please correct the errors")
//                }
                
                formModel.applayValidation()
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
        }
    }
}
