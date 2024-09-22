//
//  File.swift
//  
//
//  Created by Ahmad Sallam on 09/09/2024.
//

import Foundation
import SwiftUI

struct MultiSelectView: View {
    @Binding var selectedOption: String
    var label: String
    var options: [String]
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    
    // Tracks the selected items
    @State private var selectedItems: [String] = []
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
            
            // List of selectable items
            ForEach(options, id: \.self) { item in
                SelectableRowView(item: item,
                               isSelected: selectedItems.contains(item))
                .onTapGesture {
                    toggleSelection(of: item)
                }
            }
        }
        .padding(8.0)
    }

    // Toggles the selection state for an item
    private func toggleSelection(of item: String) {
        if self.selectedItems.contains(item) {
            self.selectedItems.removeAll(where: { $0 == item })
        } else {
            self.selectedItems.append(item)
        }
    }
}

