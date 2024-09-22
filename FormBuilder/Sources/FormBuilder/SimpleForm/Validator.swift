//
//  Validator.swift
//
//
//  Created by Abed alrahman Malkawi on 08/09/2024.
//

import Foundation

struct ValidationModel {
    let message: String
    let isValid: Bool
}

public struct RuleValidator {
    
    static func validate(field: FormField) -> ValidationModel {
        var errors = [String]()
        var isValid = true
        guard let validation = field.validation else {return ValidationModel(message: "", isValid: true)}
        
        let value = field.value?.value as? String ?? ""
        
        // Check if the field is optional
        if let isOptional = validation.isOptional, !isOptional && value.isEmpty {
            return ValidationModel(message: "This field is required.", isValid: false)
        }
        
        // Min/Max value validation for numeric input
        if let minValue = field.validation?.min, let fieldValue = Int(value), fieldValue < minValue {
            return ValidationModel(message: "Value must be greater than or equal to \(minValue).", isValid: false)
        }
        
        if let maxValue = field.validation?.max, let fieldValue = Int(value), fieldValue > maxValue {
            errors.append("Value must be less than or equal to \(maxValue).")
        }
        
//        // Min/Max length validation for string input
//        if let minLength = field.validation?.minLength, value.count < minLength {
//            errors.append("Text must be at least \(minLength) characters long.")
//        }
//        if let maxLength = field.validation?.maxLength, value.count > maxLength {
//            errors.append("Text must be no more than \(maxLength) characters long.")
//        }
//        
//        // Regex validation
//        if let regex = field.validation?.regex, !value.isEmpty {
//            let regexPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
//            if !regexPredicate.evaluate(with: value) {
//                errors.append("The field does not match the required format.")
//            }
//        }
//        
//        // Date validation (min/max date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        if let minDateString = field.validation?.minDate, let minDate = dateFormatter.date(from: minDateString),
//           let dateValue = dateFormatter.date(from: value), dateValue < minDate {
//            errors.append("Date must be on or after \(minDateString).")
//        }
//        
//        if let maxDateString = field.validation?.maxDate, let maxDate = dateFormatter.date(from: maxDateString),
//           let dateValue = dateFormatter.date(from: value), dateValue > maxDate {
//            errors.append("Date must be on or before \(maxDateString).")
//        }
//        
//        // MIME type validation (for files)
//        if let mimeTypes = field.validation?.allowedMimeTypes, !mimeTypes.isEmpty {
//            // Assume value is a file extension or MIME type string
//            let fileMimeType = value // In practice, this would come from the file metadata
//            if !mimeTypes.contains(fileMimeType) {
//                errors.append("The file type is not allowed.")
//            }
//        }
//        
//        // File size validation (for files)
//        if let maxSize = field.validation?.maxSize {
//            // Assume value is the file size in bytes (in practice, get this from the file metadata)
//            if let fileSize = Int(value), fileSize > maxSize {
//                errors.append("The file size exceeds the maximum limit of \(maxSize) bytes.")
//            }
//        }
        
        return ValidationModel(message: "", isValid: true)
    }
    
    static func greaterThanOrEqual(_ value: Int, minimumValue: Int) -> Bool {
        value >= minimumValue
    }
    
    static func min(_ value: Int, minimumValue: Int) -> Bool {
        value >= minimumValue
    }
    
    static func max(_ value: Int, maximumValue: Int) -> Bool {
        value <= maximumValue
    }
    
    static func required(_ string: String) -> Bool {
        !string.isEmpty
    }
    
    static func minLength(_ string: String, minimumLength: Int) -> Bool {
        string.count >= minimumLength
    }
    
    static func maxLength(_ string: String, maximumLength: Int) -> Bool {
        string.count <= maximumLength
    }
    
    static func requiredTrue(_ value: Bool?) -> Bool {
        value ?? false
    }
}
