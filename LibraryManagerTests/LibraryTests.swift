//
//  LibraryTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 25.04.23.
//

import XCTest

import XCTest
import LibraryManager
import ComposableArchitecture

final class LibraryTests: XCTestCase {
    func testSegmentSwitching() {
        let store = TestStore(
            initialState: Library.State.mock(),
            reducer: Library()
        )

        store.send(.didChangeSegment(.wishlist)) {
            $0.currentSegment = .wishlist
        }
    }
    
    func testDeletionActions() {
        let store = TestStore(
            initialState: Library.State.mock(),
            reducer: Library()
        )
        
        store.send(.filteredBooksDeletedAt(indexSet: .init(arrayLiteral: 0))) {
            $0.books.removeFirst()
        }
    }
    
    func testAddNewBook() {
        let store = TestStore(
            initialState: Library.State.mock(),
            reducer: Library()
        )
        
        store.send(.didTapAddBook) {
            $0.shouldNavigateToNewBook = true
        }
    }
}
