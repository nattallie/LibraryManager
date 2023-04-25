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
            $0.book.wantsToBuy = true
        }
    }
    
    func testQueueChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeQueue(true)) {
            $0.book.wantsToRead = true
        }
    }
    
    func testIsReadChanged() {
        let store = TestStore(
            initialState: BookDetails.State.mock(),
            reducer: BookDetails()
        )
        
        store.send(.didChangeIsRead(false)) {
            $0.book.isRead = false
        }
    }
    
    func testNewBookAdded() {
        let newBookID = UUID()
        let store = TestStore(
            initialState: Library.State.mock(newBook: .new(book: .new(id: newBookID))),
            reducer: Library()
        )
    
        let newBook = Book.State.new(id: newBookID, title: "New Book Title", author: "Me", owns: true, wantsToBuy: true, isRead: false)
        
        store.send(.newBookCreated(.didChangeTitle(newBook.title))) {
            $0.newBook.book.title = newBook.title
        }
        
        store.send(.newBookCreated(.didChangeAuthor(newBook.author))) {
            $0.newBook.book.author = newBook.author
        }
        
        store.send(.newBookCreated(.didChangeOwnership(newBook.owns))) {
            $0.newBook.book.owns = newBook.owns
        }
        
        store.send(.newBookCreated(.didChangeWishlist(newBook.wantsToBuy))) {
            $0.newBook.book.wantsToBuy = newBook.wantsToBuy
        }
        
        XCTAssertEqual(store.state.newBook.book, newBook)
    }
}
