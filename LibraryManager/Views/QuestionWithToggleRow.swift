//
//  QuestionWithToggleRow.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import SwiftUI

// MARK: - Question With Toggle Row
struct QuestionWithToggleRow: View {
    private let question: String
    @Binding private var isOn: Bool
    
    init(question: String, isOn: Binding<Bool>) {
        self.question = question
        self._isOn = isOn
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Toggle(question, isOn: $isOn)
                .toggleStyle(.checkmark)
        }
        .frame(alignment: .trailing)
        .onTapGesture {
            isOn.toggle()
        }
    }
}
