//
//  ErrorMessageView.swift
//
//
//  Created by Abed alrahman Malkawi on 17/09/2024.
//

import SwiftUI

struct ErrorMessageView: View {
    var message: String

    var body: some View {
        
        HStack{
            
            Text(message)
                .foregroundColor(.red)
                .transition(.opacity)
                .animation(.easeInOut)
                
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

