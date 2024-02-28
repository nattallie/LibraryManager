//
//  CheckBoxToggleStyle.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 24.04.23.
//

import SwiftUI

// MARK: - Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top, spacing: 5) {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 18, height: 18)
                .cornerRadius(5.0)
                .overlay {
                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
                .padding(.top, 2)
            configuration.label
        }
    }
}

extension ToggleStyle where Self == CheckboxToggleStyle {
    static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}
