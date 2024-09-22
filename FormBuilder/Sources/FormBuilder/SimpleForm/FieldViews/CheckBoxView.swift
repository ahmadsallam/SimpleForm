//
//  File.swift
//  SimpleForm
//
//  Created by Ahmad Sallam on 20/08/2024.
//

import Foundation
import SwiftUI

struct CheckBoxView: View {
    @Binding var isSelected: Bool
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    var item: String
    
    var body: some View {
        if !isHidden {
            VStack(alignment: .leading) {
                SelectableRowView(item: item,
                                  isSelected: isSelected, isSingleSelection: true)
                .onTapGesture {
                    isSelected = !isSelected
                }
            }
            .padding([.top, .bottom], 10.0)
        }
    }
}

