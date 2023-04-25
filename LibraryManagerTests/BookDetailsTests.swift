//
//  BookDetailsTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 25.04.23.
//

import XCTest
import LibraryManager
import ComposableArchitecture

final class BookDetailsTests: XCTestCase {
    func testTitleChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeTitle("New Book Title")) {
            $0.book.title = "New Book Title"
        }
    }
    
    func testAuthorChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeAuthor("Me")) {
            $0.book.author = "Me"
        }
    }
    
    func testOwnershipChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeOwnership(false)) {
            $0.book.owns = false
        }
    }
    
    func testWishlistChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeWishlist(true)) {
            $0.book.owns = true
        }
    }
    
    func testQueueChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeQueue(true)) {
            $0.book.owns = true
        }
    }
    
    func testIsReadChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeIsRead(true)) {
            $0.book.owns = true
        }
    }
}
