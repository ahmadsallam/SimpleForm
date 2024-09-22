//
//  DateFieldView.swift
//  
//
//  Created by Abed alrahman Malkawi on 15/09/2024.
//

import SwiftUI

struct DateFieldView: View {
    @Binding var selectedDate: Date
    var label: String
    @Binding var isEnabled: Bool
    @Binding var isHidden: Bool
    
    // Date formatter for displaying date in TextField
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        if !isHidden {
            DatePicker(
                label,
                selection: $selectedDate,
                in: ...Date(), // Limits selection to past dates
                displayedComponents: [.date] // Displays both date and time
            )
            .padding(10.0)
            .disabled(!isEnabled)
            .applyDisabledStyle(isEnabled: isEnabled)
        }
    }
}
    
