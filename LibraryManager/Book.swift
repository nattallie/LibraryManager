//
//  Book.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 15.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
struct Book: ReducerProtocol {
    // MARK: State
    struct State: Equatable, Hashable, Identifiable {
        var id: UUID
        var title: String
        var author: String
        var owns: Bool
        var wantsToBuy: Bool
        var wantsToRead: Bool
        var isRead: Bool
    }
    
    // MARK: - Action
    enum Action: Equatable {
        
    }
    
    // MARK: - Body
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

// MARK: - View
struct BookRow: View {
    let store: StoreOf<Book>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
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
            }
            .background(.clear)
            .listRowSeparator(.hidden)
        }
    }
}

// MARK: - Preview
struct Book_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(store: Store(initialState: Book.State.mock(), reducer: Book()))
    }
}
