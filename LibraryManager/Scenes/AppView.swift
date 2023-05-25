//
//  AppView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 14.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
public struct Library: ReducerProtocol {
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

// MARK: - App View
public struct AppView: View {
    let store: StoreOf<Library>
    @ObservedObject var viewStore: ViewStore<ViewState, Library.Action>
    
    // MARK: init
    public init(store: StoreOf<Library>) {
        self.store = store
        viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
    }
    
    // MARK: View State
    public struct ViewState: Equatable {
        var currentSegment: BookSegment
        
        init(state: Library.State) {
            self.currentSegment = state.currentSegment
        }
    }
    
    // MARK: App View Body
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) { 
                Picker(
                    "Library",
                    selection:
                        viewStore.binding(get: \.currentSegment, send: Library.Action.didChangeSegment)
                        .animation()
                ) {
                    ForEach(BookSegment.allCases, id: \.self) { segment in
                        Text(segment.rawValue)
                    }
                }
                    .pickerStyle(.segmented)
                    .padding(.top, 10)
                    .padding(.horizontal)
                List {
                    ForEachStore(store.scope(state: \.filteredBooks, action: Library.Action.book(id:action:))) {
                        BookRow(store: $0, fromSegment: viewStore.currentSegment)
                    }
                    .onDelete(perform: { viewStore.send(.filteredBooksDeletedAt(indexSet: $0)) })
                }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.white.opacity(0.5))
                    .shadow(color: Color.gray.opacity(0.5), radius: 5)
                NavigationLink("") {
                    BookDetailsView(
                        viewStore: ViewStore(
                            store.scope(
                                state: \.newBook,
                                action: Library.Action.newBookCreated
                            )
                        ),
                        fromSegment: .library
                    )
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add  📗") {
                        BookDetailsView(
                            viewStore: ViewStore(
                                store.scope(
                                    state: \.newBook,
                                    action: Library.Action.newBookCreated
                                )
                            ),
                            fromSegment: .library
                        )
                    }
                    .onTapGesture {
                        viewStore.send(.didTapAddBook)
                    }
                }
            })
        }
            .onAppear {
                viewStore.send(.onAppear)
            }
    }
}

// MARK: - Preview
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: Library.State.mock(),
                reducer: Library()
            )
        )
    }
}
