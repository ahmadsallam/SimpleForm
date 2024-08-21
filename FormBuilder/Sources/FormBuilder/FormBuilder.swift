// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

@available(iOS 13.0, *)
public struct FormBuilder {
    public init(name: String) {
        greet(name: name)
    }
    
    public func greet(name: String) {
        print( "Hello, \(name) to home builder!")
    }
    
    public func formView() -> some View {

        let bundle = Bundle.module // Use Bundle.module to access package resources
            if let url = bundle.url(forResource: "FormJSON", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let formModel = FormModel(from: data)
                    return AnyView(FormView(formModel: formModel))
                } catch {
                    print("Failed to load data from JSON file: \(error)")
                    return AnyView(Text("Failed to load form data"))
                }
            } else {
                print("JSON file not found in the bundle.")
                return AnyView(Text("Failed to find JSON file"))
            }
    }

}

