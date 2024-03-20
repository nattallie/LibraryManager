//
//  LibraryManagerApp.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 23.02.23.
//

import ComposableArchitecture
import SwiftUI

@main
struct LibraryManagerApp: App {
    var body: some Scene {
        WindowGroup {
            LibraryView(
                store: Store(
                    initialState: LibraryReducer.State(currentSegment: .library, books: [], searchText: "", newBook: .new()),
                    reducer: LibraryReducer()
                )
            )
        }
    }
}
