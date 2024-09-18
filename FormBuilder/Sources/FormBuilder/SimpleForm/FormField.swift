//
//  FormField.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

enum FieldType: String, Codable {
    case text
    case number
    case dropdown
    case checkbox
    case image
    case date
    case time
    case file
    case custom
    case multiSelection
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try FieldType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

enum RuleConditionType: String, Codable {
    case numeric
    case stringLength
    case regex
    case date
    case allowedMimeTypes
    case fileSize
    case dropDownDependency
    case string
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try RuleConditionType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

enum RuleOprators: String, Codable {
    case equalTo
    case notEqualTo
    case greaterThan
    case greaterThanOrEqualTo
    case lessThan
    case lessThanOrEqualTo
    case equalToOptionValue
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try RuleOprators(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

enum RuleActions: String, Codable {
    case showField
    case hideField
    case enableField
    case disableField
    case makeRequired
    case makeOptional
    case addValidationMessage
    case clearValidationMessages
    case updateOptions
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try RuleActions(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

struct FormData: Decodable {
    let fields: [FormField]
}

struct FormField: Codable, Identifiable {
    var id = UUID()
    var fieldID: String?
    var type: FieldType?
    var label: String?
    var value: AnyCodable?
    var enabled: Bool?
    var options: [String]?
    let errorMessage: String?
    let style: Style?
    let rules: [Rule]?
    let initialState: String?
    let customType: String?
    let alterOptions: [AlterOption]?
    let validation: Validation?
    var isHidden: Bool?
    let dropDownLabel: String?
    var isRequired: Bool?
    var isSelected: Bool?
    var isValid: Bool?
    
    enum CodingKeys: String, CodingKey {
        case type, label, value, enabled, fieldID,
             options, errorMessage, style,
             rules, initialState, customType,
             alterOptions, validation, isHidden,
             dropDownLabel, isRequired, isSelected
    }

    mutating func setNewValue(newValue: AnyCodable) {
        self.value = newValue
    }

    mutating func enable(newValue: Bool) {
        self.enabled = newValue
    }
    
    mutating func hide(newValue: Bool) {
        self.isHidden = newValue
    }
    
    mutating func updateOptions(_ newValue: [String]) {
        self.options = newValue
    }
    
    mutating func required(_ newValue: Bool) {
        self.isRequired = newValue
    }
    
    mutating func selected(_ newValue: Bool) {
        self.isSelected = newValue
    }
    
    mutating func isValid(_ newValue: Bool) {
        self.isValid = newValue
    }
    
}

// MARK: - AlterOption
class AlterOption: Codable {
    var options: [String]?
    var value: String?
    var isSelected: Bool? = false
}

// MARK: - Rule
struct Rule: Codable {
    let condition: Condition?
    let actions: [Action]?
}

// MARK: - Action
struct Action: Codable {
    let type: RuleActions?
    let targetField, message: String?
}

// MARK: - Condition
struct Condition: Codable {
    let type: RuleConditionType?
    let value: AnyCodable?
    let dependsOn: String?
    let conditionOperator: RuleOprators?

    enum CodingKeys: String, CodingKey {
        case type, value, dependsOn
        case conditionOperator = "operator"
    }
}

//enum ValueUnion: Codable {
//    case integer(Int)
//    case string(String)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(ValueUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueUnion"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .integer(let x):
//            try container.encode(x)
//        case .string(let x):
//            try container.encode(x)
//        }
//    }
//}

// MARK: - Style
struct Style: Codable {
    let backgroundColor, borderColor: String?
    let borderRadius, borderWidth: Int?
    let fontFamily: String?
    let fontSize: Int?
    let fontWeight: String?
    let isSingleLine: Bool?
    let keyboardType: String?
    let padding: Int?
    let textAlign, textColor: String?
}

// MARK: - Validation
struct Validation: Codable {
    let isOptional: Bool?
    let min, max: Int?
    let regex: String?
    let maxDate, minDate: String?
    let allowedMimeTypes: [String]?
    let maxSize: Int?
    let minLength, maxLength: Int?
    
    enum CodingKeys: String, CodingKey {
        case isOptional, min, max, regex, minDate, maxDate
        case allowedMimeTypes
        case maxSize, minLength, maxLength
    }
}

struct FieldBusinesRules: Decodable {
    var targetField: String
    var action: String
    var condition: String
}

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            value = arrayValue.map { $0.value }
        } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
            value = dictionaryValue.mapValues { $0.value }
        }else if let dateValue = try? container.decode(Data.self) {
            value = dateValue
        } else {
            throw DecodingError.typeMismatch(AnyCodable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported value type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if let arrayValue = value as? [Any] {
            let encodableArray = arrayValue.map { AnyCodable($0) }
            try container.encode(encodableArray)
        } else if let dictionaryValue = value as? [String: Any] {
            let encodableDictionary = dictionaryValue.mapValues { AnyCodable($0) }
            try container.encode(encodableDictionary)
        } else if let dateValue = value as? Date {
            try container.encode(dateValue)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported value type"))
        }
    }
}

