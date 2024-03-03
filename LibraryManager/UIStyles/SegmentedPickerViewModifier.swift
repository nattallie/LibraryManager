//
//  SegmentedPickerViewModifier.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 03.03.24.
//

import SwiftUI

// MARK: - Segmented Picker View Modifier
public struct SegmentedPickerViewModifier: ViewModifier {
    // MARK: init
    public init() {
        let colorAppearance = UISegmentedControl.appearance()
        colorAppearance.backgroundColor = UIColor(cgColor: ColorBook.primary2.cgColor!)
        colorAppearance.selectedSegmentTintColor = UIColor(cgColor: ColorBook.primary7.cgColor!)
        colorAppearance.setTitleTextAttributes(
            [.foregroundColor : ColorBook.primary9.cgColor!,
             .font : UIFont.boldSystemFont(ofSize: 14)],
            for: .normal
        )
    }

    // MARK: body
    public func body(content: Content) -> some View {
        content
    }
}

extension View {
    func segmentedPicker() -> some View {
        modifier(SegmentedPickerViewModifier())
    }
}
