//
//  SimpleFormApp.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct formBuilderApp: App {
    var body: some Scene {
        WindowGroup {
            if let url = Bundle.main.url(forResource: "FormJSON", withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                let formModel = FormModel(from: data)
                FormView(formModel: formModel)
            } else {
                Text("Failed to load form")
            }
        }
    }
}
