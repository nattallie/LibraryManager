//
//  CustomSearchBar.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 20.03.24.
//

import SwiftUI

// MARK: - Custom Search Bar
public struct CustomSearchBar: View {
    // MARK: Properties
    @Binding var text: String
    @State var showCancelButton: Bool = false
    private let placeHolder: String
    private var onSubmit: (() -> ())?
    
    // MARK: Init
    public init(
        placeHolder: String,
        text: Binding<String>,
        onSubmit: (() -> ())?
    ) {
        self._text = text
        self.placeHolder = placeHolder
        self.onSubmit = onSubmit
    }
        
    public var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(ColorBook.primary9)
                TextField(placeHolder, text: $text)
                    .foregroundStyle(ColorBook.primary9)
                    .background(Color.clear)
                    .tint(ColorBook.primary7)
                    .onSubmit { onSubmit?() }
                    .onTapGesture {
                        withAnimation {
                            showCancelButton = true
                        }
                    }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(ColorBook.primary0)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ColorBook.primary7, lineWidth: 1)
            )
            if showCancelButton {
                Button(
                    action: {
                        text = ""
                        hideKeyboard()
                        withAnimation {
                            showCancelButton = false
                        }
                    },
                    label: {
                        Text("Cancel")
                            .foregroundStyle(ColorBook.primary9)
                            .font(.system(size: 17, weight: .medium))
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}

// MARK: resignFirstResponder extension
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: Preview
public struct CustomSearchBar_Preview: PreviewProvider {
    public static var previews: some View {
        CustomSearchBar(placeHolder: "Search", text: .constant("New Book"), onSubmit: nil)
            .padding(10)
    }
}
