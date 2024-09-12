//
//  File.swift
//  
//
//  Created by Ahmad Sallam on 09/09/2024.
//

import Foundation
import SwiftUI

struct MultiSelectItem: Identifiable {
    let id = UUID()
    let title: String
    var isSelected: Bool
}

struct MultiSelectView: View {
    @State private var items: [MultiSelectItem] = [
        MultiSelectItem(title: "Option 1", isSelected: false),
        MultiSelectItem(title: "Option 2", isSelected: false),
        MultiSelectItem(title: "Option 3", isSelected: false)
    ]

    var body: some View {
        VStack {
            Text("Multi-Select Options")
                .font(.headline)
                .padding()

            List {
                ForEach($items) { $item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        if item.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        item.isSelected.toggle()
                    }
                }
            }
            .listStyle(.plain)

            Button(action: printSelectedItems) {
                Text("Confirm Selection")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
    }

    // Prints the selected items for demonstration purposes
    private func printSelectedItems() {
        let selectedItems = items.filter { $0.isSelected }
        print("Selected Items: \(selectedItems.map { $0.title })")
    }
}

struct MultiSelectView_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectView()
    }
}
