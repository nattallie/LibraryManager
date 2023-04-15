//
//  AppView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 14.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
struct Library: ReducerProtocol {
    // MARK: State
    struct State {
        var currentSegment: BookSegment
        var books: IdentifiedArrayOf<Book.State>
        var filteredBooks: IdentifiedArrayOf<Book.State> {
            switch currentSegment {
            case .library:
                return books.filter { $0.owns }
            case .wishlist:
                return books.filter { $0.wantsToBuy }
            case .queue:
                return books.filter { $0.wantsToRead }
            }
        }
    }
    
    // MARK: Action
    enum Action {
        case didChangeSegment(BookSegment)
        case book(id: Book.State.ID, action: Book.Action)
    }
    
    // MARK: Body
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .didChangeSegment(currentSegment):
                state.currentSegment = currentSegment
                return .none
            case .book:
                return .none
            }
        }
        .forEach(\.books, action: /Action.book(id:action:)) {
          Book()
        }
    }
}

// MARK: - AppView
struct AppView: View {
    let store: StoreOf<Library>
    @ObservedObject var viewStore: ViewStore<ViewState, Library.Action>
    
    init(store: StoreOf<Library>) {
        self.store = store
        viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
    }
    
    struct ViewState: Equatable {
        var currentSegment: BookSegment
        
        init(state: Library.State) {
            self.currentSegment = state.currentSegment
        }
    }
    
    var body: some View {
        NavigationView {
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
                .padding(.top, 20)
                .padding(.horizontal)
                List {
                    ForEachStore(store.scope(state: \.filteredBooks, action: Library.Action.book(id:action:))) {
                        BookRow(store: $0)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.5))
                .shadow(color: Color.gray.opacity(0.5), radius: 5)
            }
            .navigationTitle("Library Manager")
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
