//
//  NavigationBarTitleColorModifier.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 04.03.24.
//

import SwiftUI

// MARK: - Navigation Bar Title Color Modifier
struct NavigationBarTitleColorModifier: ViewModifier {
    var color: UIColor

    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithOpaqueBackground()
                coloredAppearance.backgroundColor = .clear
                coloredAppearance.shadowColor = .clear
                coloredAppearance.titleTextAttributes = [.foregroundColor: color, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: color, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]

                UINavigationBar.appearance().standardAppearance = coloredAppearance
                UINavigationBar.appearance().compactAppearance = coloredAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
            }
    }
}

extension View {
    func navigationBarTitleColor(_ color: Color) -> some View {
        self.modifier(NavigationBarTitleColorModifier(color: UIColor(color)))
    }
}
