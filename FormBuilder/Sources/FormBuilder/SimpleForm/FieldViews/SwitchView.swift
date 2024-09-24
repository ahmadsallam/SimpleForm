//
//  SwitchView.swift
//
//
//  Created by Abed alrahman Malkawi on 23/09/2024.
//

import SwiftUI

struct SwitchView: View {
    var label: String
    var options: [String]
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    @State private var isOn: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
            
            // List of selectable items
            ForEach(options, id: \.self) { item in
                VStack {
                    Toggle(isOn: $isOn) {
                        Text(item ?? "")
                    }
                }
            }
        }
        .padding(8.0)
    }
}
