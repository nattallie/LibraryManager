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
    private let placeHolder: String
    @Binding var text: String
    @State var showCancelButton: Bool = false
    
    // MARK: Init
    public init(
        placeHolder: String,
        text: Binding<String>
    ) {
        self._text = text
        self.placeHolder = placeHolder
    }
        
    public var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(ColorBook.primary9)
                TextField(placeHolder, text: $text)
                    .foregroundStyle(ColorBook.primary9)
                    .tint(ColorBook.primary7)
                    .onTapGesture {
                        withAnimation {
                            showCancelButton = true
                        }
                    }
            }
            .padding(.vertical, 8)
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
        CustomSearchBar(placeHolder: "Search", text: .constant("New Book"))
            .padding(10)
    }
}
