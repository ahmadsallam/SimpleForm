//
//  File.swift
//  
//
//  Created by Ahmad on 27/08/2024.
//

import Foundation

public protocol BusinessRule {
    var key: String { get }
    var editable: Bool { get }
    var mandatory: Bool { get }
    var maxValue: String { get }
    var minValue: String { get }
    var regex: String { get }
    var showIfMinValue: Bool { get }
    var mandatoryIfMinValue: Bool { get }
    
    func validate() -> Bool
}

public extension BusinessRule {
    func validate() -> Bool {
        // Example validation logic
        
        // Check if the key is not empty
        guard !key.isEmpty else {
            return false
        }
        
        // If the value is mandatory, check if the minValue is respected
        if mandatory, let min = Double(minValue), let max = Double(maxValue), min > max {
            return false
        }
        
        // Regex validation (if needed)
        if !regex.isEmpty {
            let regexPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            if !regexPredicate.evaluate(with: minValue) {
                return false
            }
        }
        
        // Further custom validation based on conditions
        if showIfMinValue && minValue.isEmpty {
            return false
        }
        
        if mandatoryIfMinValue && minValue.isEmpty {
            return false
        }
        
        // All checks passed
        return true
    }
}
