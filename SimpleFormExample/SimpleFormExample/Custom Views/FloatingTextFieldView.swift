//
//  FloatingTextFieldView.swift
//  DeomAppSwiftUI
//
//  Created by Abed alrahman Malkawi on 03/09/2024.
//

import SwiftUI

struct FloatingTextField: View {
    let textFieldHeight: CGFloat = 50
    private let placeHolderText: String
    @Binding var text: String
    @State private var isEditing = false
    public init(placeHolder: String,
                text: Binding<String>) {
        self._text = text
        self.placeHolderText = placeHolder
    }
    var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }
    var body: some View {
        ZStack(alignment: .leading) {
            TextField(!isEditing ? placeHolderText : "", text: $text, onEditingChanged: { (edit) in
                withAnimation {
                    isEditing = edit
                }
            })
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                .frame(height: textFieldHeight))
            .foregroundColor(Color.primary)
            .accentColor(Color.secondary)
            ///Floating Placeholder
            if isEditing || !text.isEmpty {
                Text(isEditing || !text.isEmpty ? placeHolderText : "")
                    .lineLimit(1)
                    .background(Color.clear)
                    .font(.caption)
                    .padding([.leading, .trailing], 6)
                    .foregroundColor(Color(UIColor.lightGray))
                    .background(Color(UIColor.systemBackground))
                    .padding(shouldPlaceHolderMove ?
                             EdgeInsets(top: 0, leading: 16, bottom: textFieldHeight, trailing: 0) :
                                EdgeInsets(top: 0, leading: 44, bottom: 0, trailing: 0))
            }
        }
    }
}

struct SecretFloatingTextField: View {
    let textFieldHeight: CGFloat = 50
    private let placeHolderText: String
    @Binding var text: String
    @State private var isEditing = false

    public init(placeHolder: String,
                text: Binding<String>) {
        self._text = text
        self.placeHolderText = placeHolder
    }
    var shouldPlaceHolderMove: Bool {
        isEditing || !(text.isEmpty)
    }
    var body: some View {
        ZStack(alignment: .leading) {
          
            SecureField(!isEditing ? placeHolderText : "", text: $text, onCommit: {
                // Event: Return key pressed
                print("Return key pressed. Password: \(text)")
            })
            .padding()
            .onTapGesture {
                // Event: Field tapped
                withAnimation {
                    self.isEditing.toggle()
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
                .frame(height: textFieldHeight))
            .foregroundColor(Color.primary)
            .accentColor(Color.secondary)
            ///Floating Placeholder
            if isEditing || !text.isEmpty {
                Text(isEditing || !text.isEmpty ? placeHolderText : "")
                    .lineLimit(1)
                    .background(Color.clear)
                    .font(.caption)
                    .padding([.leading, .trailing], 6)
                    .foregroundColor(Color(UIColor.lightGray))
                    .background(Color(UIColor.systemBackground))
                    .padding(shouldPlaceHolderMove ?
                             EdgeInsets(top: 0, leading: 16, bottom: textFieldHeight, trailing: 0) :
                                EdgeInsets(top: 0, leading: 44, bottom: 0, trailing: 0))
            }
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    @State private var width = CGFloat.zero
    @State private var labelWidth = CGFloat.zero
    
    var body: some View {
        TextField(placeholder, text: $text)
        //            .foregroundColor(.gray)
        //            .font(.system(size: 20))
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .trim(from: 0, to: 0.55)
                        .stroke(.gray, lineWidth: 1)
                    RoundedRectangle(cornerRadius: 5)
                        .trim(from: 0.57 + (0.44 * (labelWidth / width)), to: 1)
                        .stroke(.gray, lineWidth: 1)
                    Text("placeholder")
                        .foregroundColor(.gray)
                        .overlay( GeometryReader { geo in Color.clear.onAppear { labelWidth = geo.size.width }})
                        .padding(2)
                        .font(.caption)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .topLeading)
                        .offset(x: 20, y: -10)
                    
                }
            }
            .overlay( GeometryReader { geo in Color.clear.onAppear { width = geo.size.width }})
            .onChange(of: width) { _ in
                print("Width: ", width)
            }
            .onChange(of: labelWidth) { _ in
                print("labelWidth: ", labelWidth)
            }
        
        
    }
}
