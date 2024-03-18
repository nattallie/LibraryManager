//
//  BookDetailsView.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 19.04.23.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Book Details View
struct BookDetailsView: View {
    @ObservedObject var viewStore: ViewStoreOf<BookDetailsReducer>
    var fromSegment: BookSegment
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var screenTitle: String {
        viewStore.book.title.isEmpty ?
            "New Book" :
            "Book Details"
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
    init(viewStore: ViewStoreOf<BookDetailsReducer>, fromSegment: BookSegment) {
        self.viewStore = viewStore
        self.fromSegment = fromSegment
    }
    
    // MARK: Book Details View
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 20) {
                    TextField(
                        "Book Title",
                        text: Binding(
                            get: { viewStore.book.title },
                            set: { viewStore.send(.didChangeTitle($0)) }
                        )
                    )
                        .textFieldStyle(.plain)
                        .background(.clear)
                        .padding(6)
                        .foregroundColor(ColorBook.primary9)
                        .fontWeight(.medium)
                        .cornerRadius(3)
                        .autocorrectionDisabled(true)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(ColorBook.primary9)
                        .padding(.vertical, -20)
                    TextField(
                        "Author",
                        text: Binding(
                            get: { viewStore.book.author },
                            set: { viewStore.send(.didChangeAuthor($0)) }
                        )
                    )
                        .textFieldStyle(.plain)
                        .background(.clear)
                        .padding(6)
                        .foregroundColor(ColorBook.primary9)
                        .fontWeight(.medium)
                        .cornerRadius(3)
                        .autocorrectionDisabled(true)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(ColorBook.primary9)
                        .padding(.vertical, -20)
                    if !(viewStore.mode == .edit && fromSegment == .library) {
                        QuestionWithToggleRow(
                            question: "Do you have \(bookName) ?",
                            isOn: Binding(
                                get: { viewStore.book.owns },
                                set: { viewStore.send(.didChangeOwnership($0)) }
                            )
                        )
                    }
                    if !(viewStore.mode == .edit && fromSegment == .wishlist) {
                        QuestionWithToggleRow(
                            question: "Do you want to buy \(bookName) ?",
                            isOn: Binding(
                                get: { viewStore.book.wantsToBuy },
                                set: { viewStore.send(.didChangeWishlist($0)) }
                            )
                        )
                    }
                    if !(viewStore.mode == .edit && fromSegment == .queue) {
                        QuestionWithToggleRow(
                            question: "Do you want to add \(bookName) in Reading Queue ?",
                            isOn: Binding(
                                get: { viewStore.book.wantsToRead },
                                set: { viewStore.send(.didChangeQueue($0)) }
                            )
                        )
                    }
                    QuestionWithToggleRow(
                        question: "Have you read \(bookName) ?",
                        isOn: viewStore.binding(get: \.book.isRead, send: BookDetailsReducer.Action.didChangeIsRead)
                    )
                    Spacer()
                }
                .padding(.horizontal, 10)
            }
                .padding()
                .mainBackground()
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(screenTitle)
            .navigationBarItems(
                leading:
                    Button(
                        action : {
                            mode.wrappedValue.dismiss()
                            viewStore.send(.didTapBackButton)
                        }
                    ) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(ColorBook.primary9)
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
                            .foregroundColor(doneButtonIsDisabled ? ColorBook.primary4 : ColorBook.primary9)
                            .fontWeight(.semibold)
                    }
                }
                    .disabled(doneButtonIsDisabled)
            )
    }
}

// MARK: - Preview
struct BookDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        BookDetailsView(
            viewStore: ViewStore(
                .init(
                    initialState: BookDetailsReducer.State.mock(),
                    reducer: BookDetailsReducer()
                )
            ),
            fromSegment: .library
        )
    }
}

