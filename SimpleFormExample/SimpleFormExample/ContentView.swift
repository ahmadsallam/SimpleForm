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
        
        builder.formView(additionalViews: nil, formJSON: loadFormModel(), delegate: self)
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

extension ContentView: CustomViewRepresentable {
    func getCustomView(type: String) -> AnyView {
        
        switch type {
        case CustomFormViewsKeys.customOutlinedButton.rawValue:
            return AnyView(CustomAppButtonView(title: "Custom Button", type: .outlinedButton, action: {
                print("custom view tapped")
            }))
            
        case CustomFormViewsKeys.customButton.rawValue:
            return AnyView(CustomAppButtonView(title: "Custom Button", type: .defaultButton, action: {
                print("custom view tapped")
            }))
        case CustomFormViewsKeys.customTextField.rawValue:
            return AnyView(FloatingTextField(placeHolder: "Custom filed", text: $name))
        case CustomFormViewsKeys.image.rawValue:
            return AnyView(Image("ooredooIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped())
            
        default:
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    ContentView()
}
