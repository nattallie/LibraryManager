//
//  LibraryReducerTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import LibraryManager
import XCTest

final class LibraryReducerTests: XCTestCase {
    func testSegmentSwitching() {
        let store = TestStore(
            initialState: LibraryReducer.State.mock(),
            reducer: LibraryReducer()
        )

        store.send(.didChangeSegment(.wishlist)) {
            $0.currentSegment = .wishlist
        }
    }
    
    func testDeletionActions() {
        let store = TestStore(
            initialState: LibraryReducer.State.mock(),
            reducer: LibraryReducer()
        )
        
        store.send(.filteredBooksDeletedAt(indexSet: .init(arrayLiteral: 0))) {
            $0.books.removeFirst()
        }
    }
    
    func testAddNewBook() {
        let store = TestStore(
            initialState: LibraryReducer.State.mock(),
            reducer: LibraryReducer()
        )
        
        store.send(.didTapAddBook)
    }
}
