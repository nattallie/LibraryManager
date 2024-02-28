//
//  BookDetailsTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 25.04.23.
//

import ComposableArchitecture
import LibraryManager
import XCTest

final class BookDetailsTests: XCTestCase {
    func testTitleChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeTitle("New Book Title")) {
            $0.book.title = "New Book Title"
        }
    }
    
    func testAuthorChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeAuthor("Me")) {
            $0.book.author = "Me"
        }
    }
    
    func testOwnershipChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeOwnership(false)) {
            $0.book.owns = false
        }
    }
    
    func testWishlistChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeWishlist(true)) {
            $0.book.wantsToBuy = true
        }
    }
    
    func testQueueChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeQueue(true)) {
            $0.book.wantsToRead = true
        }
    }
    
    func testIsReadChanged() {
        let store = TestStore(
            initialState: BookDetailsReducer.State.mock(),
            reducer: BookDetailsReducer()
        )
        
        store.send(.didChangeIsRead(false)) {
            $0.book.isRead = false
        }
    }
    
    func testNewBookAdded() {
        let initialBookID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let store = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            TestStore(
                initialState: LibraryReducer.State.mock(newBook: .new(book: .new(id: initialBookID))),
                reducer: LibraryReducer()
            )
        }
    
        let newBook = BookRowReducer.State.new(
            id: initialBookID,
            title: "New Book Title",
            author: "Me",
            owns: true,
            wantsToBuy: true,
            isRead: false
        )
        
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
        
        store.send(.newBookCreated(.didTapDoneButton)) {
            $0.books.append(newBook)
            $0.newBook = .new(book: .new(id: initialBookID))
        }
    }
    
    func testNewBookCreationCancelled() {
        let initialBookID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let store = withDependencies {
            $0.uuid = .incrementing
        } operation: {
            TestStore(
                initialState: LibraryReducer.State.mock(newBook: .new(book: .new(id: initialBookID))),
                reducer: LibraryReducer()
            )
        }
    
        let newBook = BookRowReducer.State.new(
            id: initialBookID,
            title: "New Book Title",
            author: "Me",
            owns: true,
            wantsToBuy: true,
            isRead: false
        )
        
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
        
        store.send(.newBookCreated(.didTapBackButton)) {
            $0.newBook = .new(book: .new(id: initialBookID))
        }
    }
}
