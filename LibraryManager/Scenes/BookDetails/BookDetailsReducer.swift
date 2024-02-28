//
//  BookDetailsReducer.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import Foundation

// MARK: - Book Details Reducer
public struct BookDetailsReducer: ReducerProtocol {
    // MARK: Dependencies
    @Dependency(\.booksClient) var booksClient

    // MARK: Book Details Mode
    public enum BookDetailsMode {
        case create
        case edit
    }

    // MARK: State
    public struct State: Equatable {
        public var book: BookRowReducer.State
        public var mode: BookDetailsMode
    }
    
    // MARK: Action
    public enum Action: Equatable {
        case didTapBackButton
        case didTapDoneButton
        case didChangeTitle(_ title: String)
        case didChangeAuthor(_ author: String)
        case didChangeOwnership(_ owns: Bool)
        case didChangeWishlist(_ wantsToBuy: Bool)
        case didChangeQueue(_ wantsToRead: Bool)
        case didChangeIsRead(_ isRead: Bool)
    }
    
    // MARK: init
    public init() {}
    
    // MARK: body
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .didTapBackButton:
                if state.mode == .edit {
                    booksClient.provider.updateBook(state.book)
                }
                return .none
            case .didTapDoneButton:
                return .none
            case let .didChangeTitle(title):
                state.book.title = title
                return .none
            case let .didChangeAuthor(author):
                state.book.author = author
                return .none
            case let .didChangeOwnership(owns):
                state.book.owns = owns
                return .none
            case let .didChangeWishlist(wantsToBuy):
                state.book.wantsToBuy = wantsToBuy
                return .none
            case let .didChangeQueue(wantsToRead):
                state.book.wantsToRead = wantsToRead
                return .none
            case let .didChangeIsRead(isRead):
                state.book.isRead = isRead
                return .none
            }
        }
    }
}

// MARK: - State Mock
extension BookDetailsReducer.State {
    public static func mock(
        book: BookRowReducer.State = .mock()
    ) -> Self {
        .init(book: book, mode: .edit)
    }
    
    public static func new(
        book: BookRowReducer.State = .new()
    ) -> Self {
        .init(book: book, mode: .create)
    }
}
