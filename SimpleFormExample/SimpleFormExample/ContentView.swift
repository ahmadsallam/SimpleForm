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

    var body: some View {
        builder.formView()
    }
}

#Preview {
    ContentView()
}
