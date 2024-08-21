// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


@available(iOS 13.0, *)
public struct FormBuilder {
    public init(name: String) {
        greet(name: name)
    }
    
    public func greet(name: String) {
        print( "Hello, \(name) to home builder!")
    }
    
    func formView() -> some View {
        if let url = Bundle.main.url(forResource: "FormJSON", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let formModel = FormModel(from: data)
            return AnyView(FormView(formModel: formModel))
        } else {
            return AnyView(Text("Failed to load form"))
        }
    }

}
