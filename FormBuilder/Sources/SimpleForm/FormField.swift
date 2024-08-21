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
    var validationRules: [String]?
    var businessRules: [BusinessRule]?

    enum CodingKeys: String, CodingKey {
        case type, label, value, enabled, options, validationRules, businessRules
    }

    mutating func setNewValue(newValue: AnyCodable) {
        self.value = newValue
    }

    mutating func enable(newValue: Bool) {
        self.enabled = newValue
    }
}


struct BusinessRule: Decodable {
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

