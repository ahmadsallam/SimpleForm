//
//  CustomAppButtonView.swift
//  DeomAppSwiftUI
//
//  Created by Abed alrahman Malkawi on 03/09/2024.
//

import SwiftUI

enum AppButtonType {
    case defaultButton
    case outlinedButton
}

struct CustomAppButtonView: View {
    var title: String
//    var backGroundColor: Color = .red
    var type: AppButtonType
    var action: () -> Void
    
    init(title: String, type: AppButtonType, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            switch type {
            case .defaultButton:
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(Color.red)
                    .cornerRadius(30)
            case .outlinedButton:
                Text(title)
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.red, lineWidth: 1)
                    }
            }
        }
    }
}
