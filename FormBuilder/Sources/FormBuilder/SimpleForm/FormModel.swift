//
//  FormModel.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

public class FormModel: ObservableObject {
    @Published var fields: [FormField] = []
    @Published var isOn: Bool = false
    
    public init(from jsonData: Data) {
        do {
            let formData = try JSONDecoder().decode(FormData.self, from: jsonData)
            self.fields = formData.fields
            applyBusinessRules()
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }

    func validate() -> Bool {
//        for field in fields {
//            if let rules = field.validationRules, rules.contains("required") {
//                if let value = field.value.value as? String, value.isEmpty {
//                    return false
//                }
//            }
//        }
        return true
    }

    func applyBusinessRules() {
//        for field in fields {
//            guard let rules = field.businessRules else { continue }
//            for rule in rules {
//                if rule.condition == "isChecked" && rule.action == "enable" {
//                    if let checkboxField = fields.first(where: { $0.label == field.label }),
//                       let targetIndex = fields.firstIndex(where: { $0.label == rule.targetField }),
//                       let isChecked = checkboxField.value.value as? Bool {
//                        fields[targetIndex].enabled = isChecked
//                        isOn = isChecked
//                    }
//                }
//                
//                
//            }
//        }
    }
}
