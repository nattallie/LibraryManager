//
//  MainBackgroundViewModifier.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 03.03.24.
//

import SwiftUI

// MARK: - Main Background View Modifier
struct MainBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [ColorBook.primary2, ColorBook.primary3]),
                    startPoint: .top,
                    endPoint: .bottom
                ), 
                ignoresSafeAreaEdges: [.top, .bottom]
            )
    }
}

extension View {
    func mainBackground() -> some View {
        modifier(MainBackgroundViewModifier())
    }
}
