//
//  Validator.swift
//
//
//  Created by Abed alrahman Malkawi on 08/09/2024.
//

import Foundation

public struct RuleValidator {
    
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
