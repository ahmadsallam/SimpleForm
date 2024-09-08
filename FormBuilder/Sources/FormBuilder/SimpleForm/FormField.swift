//
//  FormField.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

enum FieldType: String, Decodable {
    case text
    case number
    case dropdown
    case checkbox

    case image
    case date
    case time
    case file
    case custom
}

struct FormData: Decodable {
    let fields: [FormField]
}

struct FormField: Decodable, Identifiable {
    var id = UUID()
    var type: FieldType
    var label: String
    var value: AnyCodable
    var enabled: Bool?
    var options: [String]?
    
    let errorMessage: String?
    let style: Style?
    let rules: [Rule]?
    let initialState: String?
    let customType: String?
    

    enum CodingKeys: String, CodingKey {
        case type, label, value, enabled, options, errorMessage, style, rules, initialState, customType
    }

    mutating func setNewValue(newValue: AnyCodable) {
        self.value = newValue
    }

    mutating func enable(newValue: Bool) {
        self.enabled = newValue
    }
}


// MARK: - Rule
struct Rule: Codable {
    let condition: Condition?
    let actions: [Action]?
}

// MARK: - Action
struct Action: Codable {
    let type, targetField, message: String?
}

// MARK: - Condition
struct Condition: Codable {
    let type: String?
    let value: ValueUnion?
    let dependsOn, conditionOperator: String?

    enum CodingKeys: String, CodingKey {
        case type, value, dependsOn
        case conditionOperator = "operator"
    }
}

enum ValueUnion: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ValueUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

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
    let regex, minDate: String?
    let allowedMIMETypes: [String]?
    let maxSize: Int?

    enum CodingKeys: String, CodingKey {
        case isOptional, min, max, regex, minDate
        case allowedMIMETypes = "allowedMimeTypes"
        case maxSize
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
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported value type"))
        }
    }
}

