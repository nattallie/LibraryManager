//
//  BookDetailsView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 19.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer
struct BookDetails: ReducerProtocol {
    // MARK: State
    struct State: Equatable {
        var book: Book.State
    }
    
    // MARK: Action
    enum Action: Equatable {
        case didTapBackButton
        case didTapDoneButton
        case didChangeTitle(_ title: String)
        case didChangeAuthor(_ author: String)
        case didChangeOwnership(_ owns: Bool)
        case didChangeWishlist(_ wantsToBuy: Bool)
        case didChangeQueue(_ wantsToRead: Bool)
        case didChangeIsRead(_ isRead: Bool)
    }
    
    // MARK: Reduce
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .didTapBackButton:
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

// MARK: - Book Details View
struct BookDetailsView: View {
    let store: StoreOf<BookDetails>
    @ObservedObject var viewStore: ViewStore<BookDetails.State, BookDetails.Action>
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var screenTitle: String {
        viewStore.book.title.isEmpty ?
            "New Book" :
            "\(viewStore.book.title) - \(viewStore.book.author)"
    }
    
    var bookName: String {
        viewStore.book.title.isEmpty ? "this book" : "\'\(viewStore.book.title)\'"
    }
    
    init(store: StoreOf<BookDetails>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField(
                    "Book Title",
                    text: Binding(
                        get: { viewStore.book.title },
                        set: { viewStore.send(.didChangeTitle($0)) }
                    )
                )
                    .textFieldStyle(.roundedBorder)
                TextField(
                    "Author",
                    text: Binding(
                        get: { viewStore.book.author },
                        set: { viewStore.send(.didChangeAuthor($0)) }
                    )
                )
                    .textFieldStyle(.roundedBorder)
                QuestionWithToggleRow(
                    question: "Do you have \(bookName) ?",
                    isOn: Binding(
                        get: { viewStore.book.owns },
                        set: { viewStore.send(.didChangeOwnership($0)) }
                    )
                )
                QuestionWithToggleRow(
                    question: "Do you want to buy \(bookName) ?",
                    isOn: Binding(
                        get: { viewStore.book.wantsToBuy },
                        set: { viewStore.send(.didChangeWishlist($0)) }
                    )
                )
                QuestionWithToggleRow(
                    question: "Do you want to add \(bookName) in Reading Queue ?",
                    isOn: Binding(
                        get: { viewStore.book.wantsToRead },
                        set: { viewStore.send(.didChangeQueue($0)) }
                    )
                )
                QuestionWithToggleRow(
                    question: "Have you read \(bookName) ?",
                    isOn: viewStore.binding(get: \.book.isRead, send: BookDetails.Action.didChangeIsRead)
                )
                Spacer()
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
                    ) { Image(systemName: "arrow.left") },
                trailing: Button(
                    action : {
                        mode.wrappedValue.dismiss()
                        viewStore.send(.didTapDoneButton)
                    }
                ) { Text("Done") }
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
        }
        .frame(alignment: .trailing)
    }
}

struct BookDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        BookDetailsView(store:
                .init(
                    initialState: BookDetails.State.mock(),
                    reducer: BookDetails()
                )
        )
    }
}

