//
//  AppView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 14.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Library View
public struct LibraryView: View {
    let store: StoreOf<LibraryReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, LibraryReducer.Action>
    
    // MARK: init
    public init(store: StoreOf<LibraryReducer>) {
        self.store = store
        viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
    }
    
    // MARK: View State
    public struct ViewState: Equatable {
        var currentSegment: BookSegment
        
        init(state: LibraryReducer.State) {
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
                        viewStore.binding(get: \.currentSegment, send: LibraryReducer.Action.didChangeSegment)
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
                    ForEachStore(store.scope(state: \.filteredBooks, action: LibraryReducer.Action.book(id:action:))) {
                        BookRowView(store: $0, fromSegment: viewStore.currentSegment)
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
                                action: LibraryReducer.Action.newBookCreated
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
                                    action: LibraryReducer.Action.newBookCreated
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
        LibraryView(
            store: Store(
                initialState: LibraryReducer.State.mock(),
                reducer: LibraryReducer()
            )
        )
    }
}
