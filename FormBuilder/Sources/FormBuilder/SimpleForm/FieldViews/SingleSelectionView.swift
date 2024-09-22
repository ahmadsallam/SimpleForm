//
//  SingleSelectionView.swift
//
//
//  Created by Abed alrahman Malkawi on 18/09/2024.
//

import SwiftUI


struct SingleSelectionView: View {
    @Binding var selectedOption: String
    var label: String
    var options: [String]
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool

    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
            
            // List of selectable items
            ForEach(options, id: \.self) { item in
                SelectableRowView(item: item,
                                  isSelected: selectedOption == item ,
                                  isSingleSelection: true)
                .onTapGesture {
                    selectedOption = item
                }
            }
        }
        .padding(8.0)
    }
}
