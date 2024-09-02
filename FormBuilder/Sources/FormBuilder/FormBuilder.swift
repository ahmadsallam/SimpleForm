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
    
    public func formView(additionalViews: [AnyView]?, formJSON: FormModel?) -> some View {
        if let formModel = formJSON {
            return AnyView(FormView(formModel: formModel, additionalViews: additionalViews ?? []))
        } else {
            return AnyView(Text("Failed to load form data"))
        }
    }

}

