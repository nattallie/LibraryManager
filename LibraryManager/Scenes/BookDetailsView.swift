//
//  BookDetailsView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 19.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
public struct BookDetails: ReducerProtocol {
    // MARK: State
    public struct State: Equatable {
        public var book: Book.State
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
    
    // MARK: Dependencies
    @Dependency(\.booksClient) var booksClient
    
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
    
    // MARK: Book Details Mode
    public enum BookDetailsMode {
        case create
        case edit
    }
}

// MARK: - Book Details View
struct BookDetailsView: View {
    let store: StoreOf<BookDetails>
    @ObservedObject var viewStore: ViewStore<BookDetails.State, BookDetails.Action>
    var fromSegment: BookSegment
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var screenTitle: String {
        viewStore.book.title.isEmpty ?
            "New Book" :
            "\(viewStore.book.title) - \(viewStore.book.author)"
    }
    
    var bookName: String {
        viewStore.book.title.isEmpty ? "this book" : "\'\(viewStore.book.title)\'"
    }
    
    var backButtonIsDisabled: Bool {
        switch viewStore.mode {
        case .create:
            return false
        case .edit:
            return !isValidData
        }
    }
    
    var doneButtonIsDisabled: Bool {
        !isValidData
    }
    
    var doneButtonIsHidden: Bool {
        switch viewStore.mode {
        case .create:
            return false
        case .edit:
            return true
        }
    }
    
    var isValidData: Bool {
        !viewStore.book.title.isEmpty &&
        !viewStore.book.author.isEmpty &&
        (viewStore.book.wantsToBuy || viewStore.book.wantsToRead || viewStore.book.owns)
    }
    
    // MARK: init
    init(store: StoreOf<BookDetails>, fromSegment: BookSegment) {
        self.store = store
        self.viewStore = ViewStore(store)
        self.fromSegment = fromSegment
    }
    
    // MARK: Book Details View
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if !viewStore.book.title.isEmpty {
                    Text(screenTitle)
                        .font(.system(size: 20))
                        .padding(.vertical, 15)
                }
                VStack(alignment: .leading, spacing: 20) {
                    TextField(
                        "Book Title",
                        text: Binding(
                            get: { viewStore.book.title },
                            set: { viewStore.send(.didChangeTitle($0)) }
                        )
                    )
                        .textFieldStyle(.roundedBorder)
                        .border(Color.black)
                        .cornerRadius(3)
                        .autocorrectionDisabled(true)
                    TextField(
                        "Author",
                        text: Binding(
                            get: { viewStore.book.author },
                            set: { viewStore.send(.didChangeAuthor($0)) }
                        )
                    )
                        .textFieldStyle(.roundedBorder)
                        .border(Color.black)
                        .cornerRadius(3)
                        .autocorrectionDisabled(true)
                    if !(viewStore.mode == .edit && fromSegment == .library) {
                        QuestionWithToggleRow(
                            question: "Do you have \(bookName) ?  📚",
                            isOn: Binding(
                                get: { viewStore.book.owns },
                                set: { viewStore.send(.didChangeOwnership($0)) }
                            )
                        )
                        .padding(.leading)
                    }
                    if !(viewStore.mode == .edit && fromSegment == .wishlist) {
                        QuestionWithToggleRow(
                            question: "Do you want to buy \(bookName) ?  🛍",
                            isOn: Binding(
                                get: { viewStore.book.wantsToBuy },
                                set: { viewStore.send(.didChangeWishlist($0)) }
                            )
                        )
                        .padding(.leading)
                    }
                    if !(viewStore.mode == .edit && fromSegment == .queue) {
                        QuestionWithToggleRow(
                            question: "Do you want to add \(bookName) in Reading Queue ?  📖",
                            isOn: Binding(
                                get: { viewStore.book.wantsToRead },
                                set: { viewStore.send(.didChangeQueue($0)) }
                            )
                        )
                        .padding(.leading)
                    }
                    QuestionWithToggleRow(
                        question: "Have you read \(bookName) ?  ✔️",
                        isOn: viewStore.binding(get: \.book.isRead, send: BookDetails.Action.didChangeIsRead)
                    )
                        .padding(.leading)
                    Spacer()
                }
            }
                .padding()
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    Button(
                        action : {
                            mode.wrappedValue.dismiss()
                            viewStore.send(.didTapBackButton)
                        }
                    ) {
                        Image(systemName: "chevron.left")
                        
                    }
                    .disabled(backButtonIsDisabled),
                trailing: Button(
                    action : {
                        mode.wrappedValue.dismiss()
                        viewStore.send(.didTapDoneButton)
                    }
                ) {
                    if !doneButtonIsHidden {
                        Text("Done")                        
                    }
                }
                    .disabled(doneButtonIsDisabled)
            )
    }
}

// MARK: - Question With Toggle Row
struct QuestionWithToggleRow: View {
    private let question: String
    @Binding private var isOn: Bool
    
    init(question: String, isOn: Binding<Bool>) {
        self.question = question
        self._isOn = isOn
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Toggle(question, isOn: $isOn)
                .toggleStyle(.checkmark)
        }
        .frame(alignment: .trailing)
        .onTapGesture {
            isOn.toggle()
        }
    }
}

// MARK: - Preview
struct BookDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        BookDetailsView(
            store:
                .init(
                    initialState: BookDetails.State.mock(),
                    reducer: BookDetails()
                ),
            fromSegment: .library
        )
    }
}

