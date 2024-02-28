//
//  Book.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 15.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
public struct Book: ReducerProtocol {
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

// MARK: - Book Row
struct BookRow: View {
    let store: StoreOf<Book>
    @State var isShowingDetailsView: Bool = false
    var fromSegment: BookSegment
    
    // MARK: Book Row View
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.white
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        isShowingDetailsView.toggle()
                    }
                HStack(spacing: 4) {
                    VStack(alignment: .leading) {
                        Text(viewStore.title)
                            .font(.headline)
                        Text(viewStore.author)
                            .font(.subheadline)
                    }
                    Spacer()
                    if viewStore.isRead {
                        VStack {
                            Image(systemName: "checkmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.green.opacity(0.8))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                        }
                        .frame(alignment: .trailing)
                    }
                    NavigationLink("", value: "")
                        .navigationDestination(isPresented: $isShowingDetailsView) {
                            BookDetailsView(
                                viewStore: ViewStore(
                                    store.scope(
                                        state: \.bookDetails,
                                        action: Book.Action.bookDetails
                                    )
                                ),
                                fromSegment: fromSegment
                            )
                        }
                        .frame(width: 0, height: 0)
                        .hidden()
                }
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                switch fromSegment {
                case .library:
                    librarySwipeActions(viewStore: viewStore)
                case .wishlist:
                    wishlistSwipeActions(viewStore: viewStore)
                case .queue:
                    queueSwipeActions(viewStore: viewStore)
                }
            }
            .onTapGesture {
                isShowingDetailsView.toggle()
            }
            .background(.clear)
            .listRowSeparator(.hidden)
        }
    }
    
    // MARK: Swipe Actions Views
    private struct librarySwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<Book>
        
        var body: some View {
            Button("📖") {
                viewStore.send(.didTapQueueSwipe)
            }.tint(viewStore.wantsToRead ? .red : .green)
            Button("📚") {
                viewStore.send(.didTapRemoveFromLibrary)
            }.tint(.red)
        }
    }
    
    private struct wishlistSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<Book>
        
        var body: some View {
            Button("📚") {
                viewStore.send(.didTapAddToLibrarySwipe)
            }.tint(.green)
            Button("🛍") {
                viewStore.send(.didTapRemoveFromWishlist)
            }.tint(.red)
        }
    }
    
    private struct queueSwipeActions: View {
        @ObservedObject var viewStore: ViewStoreOf<Book>
        
        var body: some View {
            Button("✔️") {
                viewStore.send(.didTapHaveReadSwipe)
            }.tint(.green)
            Button("📖") {
                viewStore.send(.didTapRemoveFromQueue)
            }.tint(.red)
        }
    }
}

// MARK: - Preview
struct Book_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(store: Store(initialState: Book.State.mock(), reducer: Book()), fromSegment: .library)
    }
}
