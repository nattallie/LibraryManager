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
        
        var bookDetails: BookDetails.State {
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
    
    // MARK: - Action
    enum Action: Equatable {
        case bookDetails(BookDetails.Action)
    }
    
    // MARK: - Body
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .bookDetails(_):
                return .none
            }
        }
        Scope(state: \.bookDetails, action: /Action.bookDetails) {
            BookDetails()
        }
    }
}

// MARK: - Book Row
struct BookRow: View {
    let store: StoreOf<Book>
    @State var isShowingDetailsView: Bool = false
    
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
                    NavigationLink(
                        destination: BookDetailsView(
                            store: store.scope(
                                    state: \.bookDetails,
                                    action: Book.Action.bookDetails
                            )
                        ),
                        isActive: $isShowingDetailsView
                    ) {
                        Rectangle().opacity(0)
                    }
                    .frame(width: 0, height: 0)
                    .hidden()
                }
            }
            .onTapGesture {
                isShowingDetailsView.toggle()
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
