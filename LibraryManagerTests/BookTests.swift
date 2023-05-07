//
//  BookTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 25.04.23.
//

import XCTest
import LibraryManager
import ComposableArchitecture

final class BookTests: XCTestCase {
    func testQueueSwipe() {
        let store = TestStore(
            initialState: Book.State.mock(),
            reducer: Book()
        )
        
        store.send(.didTapQueueSwipe) {
            $0.wantsToRead = true
        }
        
        store.receive(.makeUpdate)
    }
    
    func testLibrarySwipe() {
        let store = TestStore(
            initialState: Book.State.mock(owns: false, wantsToBuy: true),
            reducer: Book()
        )
        
        store.send(.didTapAddToLibrarySwipe) {
            $0.owns = true
            $0.wantsToBuy = false
        }
        
        store.receive(.makeUpdate)
    }
    
    func testHaveReadSwipe() {
        let store = TestStore(
            initialState: Book.State.mock(wantsToRead: true, isRead: false),
            reducer: Book()
        )
        
        store.send(.didTapHaveReadSwipe) {
            $0.isRead = true
            $0.wantsToRead = false
        }
        
        store.receive(.makeUpdate)
    }
    
    func testRemoveFromLibrary() {
        let store = TestStore(
            initialState: Book.State.mock(owns: true),
            reducer: Book()
        )
        
        store.send(.didTapRemoveFromLibrary) {
            $0.owns = false
        }
        
        store.receive(.makeUpdate)
    }
    
    func testRemoveFromWishlist() {
        let store = TestStore(
            initialState: Book.State.mock(wantsToBuy: true),
            reducer: Book()
        )
        
        store.send(.didTapRemoveFromWishlist) {
            $0.wantsToBuy = false
        }
        
        store.receive(.makeUpdate)
    }
    
    func testRemoveFromQueue() {
        let store = TestStore(
            initialState: Book.State.mock(wantsToRead: true),
            reducer: Book()
        )
        
        store.send(.didTapRemoveFromQueue) {
            $0.wantsToRead = false
        }
        
        store.receive(.makeUpdate)
    }
}
