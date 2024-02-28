//
//  LibraryReducer.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import Foundation

// MARK: - Library Reducer
public struct LibraryReducer: ReducerProtocol {
    // MARK: State
    public struct State: Equatable {
        public var currentSegment: BookSegment
        public var books: IdentifiedArrayOf<Book.State>
        public var filteredBooks: IdentifiedArrayOf<Book.State> {
            switch currentSegment {
            case .library:
                return .init(uniqueElements: books.filter { $0.owns }.sorted(by: { $0.author < $1.author} ))
            case .wishlist:
                return .init(uniqueElements: books.filter { $0.wantsToBuy }.sorted(by: { $0.author < $1.author} ))
            case .queue:
                return .init(uniqueElements: books.filter { $0.wantsToRead }.sorted(by: { $0.author < $1.author} ))
            }
        }
        public var newBook: BookDetails.State
    }
    
    // MARK: Action
    public enum Action {
        case onAppear
        case didChangeSegment(BookSegment)
        case book(id: Book.State.ID, action: Book.Action)
        case didTapAddBook
        case newBookCreated(BookDetails.Action)
        case newBookNavigationActivityChanged
        case filteredBooksDeletedAt(indexSet: IndexSet)
    }
    
    // MARK: Dependencies
    @Dependency(\.uuid) var uuid
    @Dependency(\.booksClient) var booksClient
    
    // MARK: init
    public init() {}
    
    // MARK: Reducer Body
    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
        .forEach(\.books, action: /Action.book(id:action:)) {
          Book()
        }
        Scope(state: \.newBook, action: /Action.newBookCreated) {
            BookDetails()
        }
    }
    
    // MARK: core Reducer
    private func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.books = .init(uniqueElements: booksClient.provider.fetchAllBooks())
            return .none
        case let .didChangeSegment(currentSegment):
            state.currentSegment = currentSegment
            return .none
        case .book:
            return .none
        case .didTapAddBook:
            return .none
        case .newBookNavigationActivityChanged:
            return .none
        case .newBookCreated(.didTapDoneButton):
            state.books.append(state.newBook.book)
            booksClient.provider.addNewBook(state.newBook.book)
            state.newBook = .new(book: .new(id: uuid()))
            return .none
        case .newBookCreated(.didTapBackButton):
            state.newBook = .new(book: .new(id: uuid()))
            return .none
        case let .filteredBooksDeletedAt(indexSet):
            indexSet.forEach { index in
                booksClient.provider.removeBook(state.filteredBooks[index])
                state.books.remove(state.filteredBooks[index])
            }
            return .none
        default:
            return .none
        }
    }
}
