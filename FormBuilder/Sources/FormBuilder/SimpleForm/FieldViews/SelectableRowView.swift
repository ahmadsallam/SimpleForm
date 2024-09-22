//
//  SelectableRowView.swift
//
//
//  Created by Abed alrahman Malkawi on 18/09/2024.
//

import SwiftUI

// Row view for each selectable item
struct SelectableRowView: View {
    let item: String
    let isSelected: Bool
    var isSingleSelection: Bool = false
    var body: some View {
        HStack(spacing: 4.0) {
            if isSelected {
                Image(systemName: isSingleSelection ? "checkmark.circle.fill" : "checkmark.square.fill")
                    .foregroundColor(.blue) // Display checkmark if selected
            } else {
                Image(systemName: isSingleSelection ? "circle" : "square")
                    .foregroundColor(.blue)
            }
            
            Text(self.item)
        }
    }
}

