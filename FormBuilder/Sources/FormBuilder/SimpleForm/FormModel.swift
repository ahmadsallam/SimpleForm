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
    @Published var isOn: Bool = true
    
    public init(from jsonData: Data) {
        do {
            let formData = try JSONDecoder().decode(FormData.self, from: jsonData)
            self.fields = formData.fields
//            self.fields = formData.fields.filter {$0.type == .dropdown}
            applyBusinessRules()
        } catch {
            print("Failed to parse JSON: \(error)")
        }
    }

    // Function to format the selected date
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Custom date format
        return dateFormatter.string(from: date)
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
        for field in fields {
            guard let rules = field.rules else { return }
            
            for rule in rules {
                if let condition = rule.condition {
                    if let dependsOn = rule.condition?.dependsOn {
                        // Find the dependent field
                        if let dependentField = fields.first(where: { $0.fieldID == dependsOn }) {
                            // Evaluate the condition based on the dependent field's value
                            let dependentValue = dependentField.value?.value ?? ""
                            let isValid = evaluateCondition(rule, dependentValue: dependentValue, field: field)
                            performRuleAction(isValid:isValid, actions: rule.actions, field: field)
                            
                        }
                    }
                }
            }
        }
    }

    // MARK: Step one Evaluate Condition
    func evaluateCondition(_ rule: Rule, dependentValue: Any, field: FormField) -> Bool {
        guard let condition = rule.condition else {return true}
        switch condition.type {
        case .stringLength:
            if let conditionValue = Int((condition.value?.value as? String) ?? ""),
               let dependentIntValue = (dependentValue as? String)?.count,
               let operatorType = condition.conditionOperator {
                let isValid = evaluateRuleOperator(lhs: dependentIntValue, rhs: conditionValue, operatorType: operatorType)
                return isValid
            }
        case .numeric:
            if let conditionValue = condition.value?.value as? String,
               let dependentStringValue = dependentValue as? String {
                return dependentStringValue == conditionValue
            }
            if let conditionValue = condition.value?.value as? Int,
               let dependentIntValue = dependentValue as? Int {
                return dependentIntValue == conditionValue
            }
        case .dropDownDependency:
            if let dependentValue = dependentValue as? String,
               let operatorType = condition.conditionOperator,
               let alterOptions = field.alterOptions {
                var isValid = false
                _ = alterOptions.map { model in
                    let selectedOption = evaluateRuleOperator(lhs: dependentValue,
                                                            rhs: model.value ?? "",
                                                            operatorType: operatorType)
                    model.isSelected = selectedOption
                    if selectedOption {
                        isValid = true
                    }
                }
                return isValid
            }
        case .string:
            if let conditionValue = condition.value?.value as? String,
               let dependentValue = dependentValue as? String,
               let operatorType = condition.conditionOperator {
                let isValid = evaluateRuleOperator(lhs: dependentValue, rhs: conditionValue, operatorType: operatorType)
                return isValid
            }
            
        case .date:
            if let conditionDate = condition.value?.value as? String,
               let dependentDate = dependentValue as? Date,
               let operatorType = condition.conditionOperator {
                let dependentDateString = formattedDate(dependentDate)
                let isValid = evaluateRuleOperator(lhs: dependentDateString, rhs: conditionDate, operatorType: operatorType)
                return isValid
            }
        default:
            return false
        }
        return false
    }
    
    func resetDependentChileds(filedId: String) {
        for (index, field) in fields.enumerated() {
            
            _ = field.rules?.filter {$0.condition?.dependsOn == filedId}.map {model in
                fields[index].setNewValue(newValue: AnyCodable(field.dropDownLabel ?? ""))
                resetDependentChileds(filedId: fields[index].fieldID ?? "")
                
            }
        }
    }

    func evaluateDropDownDependencyRule(filed: FormField, dependentValue: String, operatorType: RuleOprators) {
    }

    //MARK: Step two Evaluate Rule Operator
    func evaluateRuleOperator<T: Comparable>(lhs: T, rhs: T, operatorType: RuleOprators) -> Bool {
        switch operatorType {
        case .equalTo, .equalToOptionValue:
            return lhs == rhs
        case .greaterThan:
            return lhs > rhs
        case .greaterThanOrEqualTo:
            return lhs >= rhs
        case .lessThan:
            return lhs < rhs
        case .lessThanOrEqualTo:
            return lhs <= rhs
        case .notEqualTo:
            return lhs != rhs
        case .unknown:
            return true
        }
    }
    
    //MARK: Step three Evaluate Perform Rule Action
    func performRuleAction(isValid: Bool, actions: [Action]?, field: FormField) {
        actions?.forEach { action in
            
            guard let targetFieldID = action.targetField, let targetIndex = fields.firstIndex(where: { $0.fieldID == targetFieldID }) else {return}
            switch action.type {
            case .showField:
                fields[targetIndex].hide(newValue: !isValid)
            case .hideField:
                fields[targetIndex].hide(newValue: isValid)
            case .enableField:
                fields[targetIndex].enable(newValue: isValid)
            case .disableField:
                fields[targetIndex].enable(newValue: !isValid)
            case .updateOptions:
                let newOptions = field.alterOptions?.first(where: {$0.isSelected ?? false})?.options
                fields[targetIndex].updateOptions(newOptions ?? [])
            case .makeRequired:
                fields[targetIndex].required(true)
            case .makeOptional:
                fields[targetIndex].required(false)
            default:
                break
            }
        }
    }

//    func applyBusinessRules() {
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
//    }
}
