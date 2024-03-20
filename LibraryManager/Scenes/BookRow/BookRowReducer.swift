//
//  BookRowReducer.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import ComposableArchitecture
import Foundation

// MARK: - Reducer
public struct BookRowReducer: ReducerProtocol {
    // MARK: State
    public struct State: Equatable, Hashable, Identifiable {
        public var id: UUID
        public var title: String
        public var author: String
        public var owns: Bool
        public var wantsToBuy: Bool
        public var wantsToRead: Bool
        public var isRead: Bool
        
        var bookDetails: BookDetailsReducer.State {
            get {
                .init(
                    book: .init(
                        id: id,
                        title: title,
                        author: author,
                        owns: owns,
                        wantsToBuy: wantsToBuy,
                        wantsToRead: wantsToRead,
                        isRead: isRead
                    ),
                    mode: .edit
                )
            }
            set {
                self.id = newValue.book.id
                self.title = newValue.book.title
                self.author = newValue.book.author
                self.owns = newValue.book.owns
                self.wantsToBuy = newValue.book.wantsToBuy
                self.wantsToRead = newValue.book.wantsToRead
                self.isRead = newValue.book.isRead
            }
        }
        
        func containsText(_ text: String) -> Bool {
            text.isEmpty || 
            author.lowercased().contains(text.lowercased()) ||
            title.lowercased().contains(text.lowercased())
        }
    }
    
    // MARK: Action
    public enum Action: Equatable {
        case bookDetails(BookDetailsReducer.Action)
        case didTapQueueSwipe
        case didTapAddToLibrarySwipe
        case didTapHaveReadSwipe
        case didTapRemoveFromLibrary
        case didTapRemoveFromWishlist
        case didTapRemoveFromQueue
    }
    
    // MARK: Dependencies
    @Dependency(\.booksClient) var booksClient
    
    // MARK: init
    public init() {}
    
    // MARK: Body
    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
        Scope(state: \.bookDetails, action: /Action.bookDetails) {
            BookDetailsReducer()
        }
    }
    
    // MARK: core reducer
    private func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .bookDetails(_):
            return .none
        case .didTapQueueSwipe:
            state.wantsToRead.toggle()
            makeUpdate(state: &state)
            return .none
        case .didTapAddToLibrarySwipe:
            state.owns = true
            state.wantsToBuy = false
            makeUpdate(state: &state)
            return .none
        case .didTapHaveReadSwipe:
            state.isRead = true
            state.wantsToRead = false
            makeUpdate(state: &state)
            return .none
        case .didTapRemoveFromLibrary:
            state.owns = false
            makeUpdate(state: &state)
            return .none
        case .didTapRemoveFromWishlist:
            state.wantsToBuy = false
            makeUpdate(state: &state)
            return .none
        case .didTapRemoveFromQueue:
            state.wantsToRead = false
            makeUpdate(state: &state)
            return .none
        }
    }
    
    private func makeUpdate(state: inout State) {
        if isRemovedFromAllSegments(state) {
            booksClient.provider.removeBook(state.bookDetails.book)
        } else {
            booksClient.provider.updateBook(state.bookDetails.book)
        }
    }
    
    private func isRemovedFromAllSegments(_ state: State) -> Bool {
        !state.owns && !state.wantsToBuy && !state.wantsToRead
    }
}

// MARK: Entity Converter
extension BookRowReducer.State {
    public static func from(_ entity: BookEntity) -> Self {
        .init(
            id: entity.id!,
            title: entity.title ?? "",
            author: entity.author ?? "",
            owns: entity.owns,
            wantsToBuy: entity.wantsToBuy,
            wantsToRead: entity.wantsToRead,
            isRead: entity.isRead
        )
    }
}

// MARK: State Mock
extension BookRowReducer.State {
    public static func mock(
        id: UUID = UUID(),
        title: String = "Stranger",
        author: String = "Albert Camus",
        owns: Bool = true,
        wantsToBuy: Bool = false,
        wantsToRead: Bool = false,
        isRead: Bool = true
    ) -> Self {
        .init(
            id: id,
            title: title,
            author: author,
            owns: owns,
            wantsToBuy: wantsToBuy,
            wantsToRead: wantsToRead,
            isRead: isRead
        )
    }
    
    public static func new(
        id: UUID = UUID(),
        title: String = "",
        author: String = "",
        owns: Bool = false,
        wantsToBuy: Bool = false,
        wantsToRead: Bool = false,
        isRead: Bool = false
    ) -> Self {
        .init(
            id: id,
            title: title,
            author: author,
            owns: owns,
            wantsToBuy: wantsToBuy,
            wantsToRead: wantsToRead,
            isRead: isRead
        )
    }
}
