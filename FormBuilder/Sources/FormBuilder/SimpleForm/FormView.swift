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

                case .number:
                    NumberFieldView(
                        value: Binding(
                            get: { field.value?.value as? String ?? "" },
                            set: { newValue in
                                field.setNewValue(newValue: AnyCodable(newValue))
                                formModel.applyBusinessRules()
                            }
                        ), label: field.label ?? "",
                        isEnabled: field.enabled ?? true)
                    .applyDisabledStyle(isEnabled: true)
                    
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
                                 item: field.label ?? "")
                    
                case .image:
                    Image(field.value?.value as? String ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
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
                                                    set: { newValue in field.hide(newValue: newValue)}))
                    
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
                        get: { field.value?.value as? String ?? (field.dropDownLabel ?? "")/*field.options?.first ?? ""*/ },
                        set: { newValue in
                            field.setNewValue(newValue: AnyCodable(newValue))
                            formModel.applyBusinessRules() }),
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
