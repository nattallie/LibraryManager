//
//  BookRowTests.swift
//  LibraryManagerTests
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import LibraryManager
import XCTest

final class BookRowTests: XCTestCase {
    func testQueueSwipe() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapQueueSwipe) {
            $0.wantsToRead = true
        }
    }
    
    func testLibrarySwipe() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(owns: false, wantsToBuy: true),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapAddToLibrarySwipe) {
            $0.owns = true
            $0.wantsToBuy = false
        }
    }
    
    func testHaveReadSwipe() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(wantsToRead: true, isRead: false),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapHaveReadSwipe) {
            $0.isRead = true
            $0.wantsToRead = false
        }
    }
    
    func testRemoveFromLibrary() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(owns: true),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapRemoveFromLibrary) {
            $0.owns = false
        }
    }
    
    func testRemoveFromWishlist() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(wantsToBuy: true),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapRemoveFromWishlist) {
            $0.wantsToBuy = false
        }
    }
    
    func testRemoveFromQueue() {
        let store = TestStore(
            initialState: BookRowReducer.State.mock(wantsToRead: true),
            reducer: BookRowReducer()
        )
        
        store.send(.didTapRemoveFromQueue) {
            $0.wantsToRead = false
        }
    }
}
