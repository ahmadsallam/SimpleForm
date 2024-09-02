//
//  ContentView.swift
//  SimpleFormExample
//
//  Created by Ahmad on 21/08/2024.
//

import SwiftUI
import FormBuilder

struct ContentView: View {
    
    let builder = FormBuilder(name: "Adam")
    @State var isOn  = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var notificationsEnabled: Bool = true
    @State private var selectedColor: Color = .red
    @State private var birthdate: Date = Date()
    
    var body: some View {
        
        builder.formView(
            
            additionalViews: [AnyView(
                VStack(alignment: .leading, spacing: 20, content: {
                    
                    Section(header:
                                Text("Preferences")
                        .font(.headline)
                        .bold()
                    ) {
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Enable Notifications")
                        }
                        
                        Picker("Favorite Color", selection: $selectedColor) {
                            Text("Red").tag(Color.red)
                            Text("Green").tag(Color.green)
                            Text("Blue") .tag(Color.blue)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Additional Information")
                        .font(.headline)
                        .bold()
                    ) {
                        DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                    }
                    
                    
                })
                
                
            )], formJSON: loadFormModel())
    }
    
    public func loadFormModel() -> FormModel? {
        let bundle = Bundle.main // Use Bundle.module to access package resources
        if let url = bundle.url(forResource: "FormJSON", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let formModel = FormModel(from: data)
                return formModel
            } catch {
                print("Failed to load data from JSON file: \(error)")
                return nil
            }
        } else {
            print("JSON file not found in the bundle.")
            return nil
        }
    }

}

#Preview {
    ContentView()
}
