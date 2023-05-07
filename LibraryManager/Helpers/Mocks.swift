//
//  Mocks.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 15.04.23.
//

import ComposableArchitecture
import Foundation

// MARK: - Library.State
extension Library.State {
    public static func mock(
        currentSegment: BookSegment = .library,
        books: IdentifiedArrayOf<Book.State> = [
            .mock(
                wantsToRead: true,
                isRead: false
            ),
            .mock(
                title: "The Fall",
                author: "Albert Camus",
                owns: true
            ),
            .mock(
                title: "Plague",
                author: "Albert Camus",
                owns: false,
                wantsToBuy: true
            ),
            .mock(
                title: "Karavani",
                author: "Jemal Karchkhadze",
                owns: true,
                wantsToBuy: true,
                wantsToRead: true,
                isRead: true
            )
        ],
        newBook: BookDetails.State = .new(),
        searchText: String = ""
    ) -> Self {
        .init(
            currentSegment: currentSegment,
            books: books,
            newBook: newBook,
            searchText: searchText
        )
    }
}

// MARK: - Book.State
extension Book.State {
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

// MARK: - BookDetails.State
extension BookDetails.State {
    public static func mock(
        book: Book.State = .mock()
    ) -> Self {
        .init(book: book, mode: .edit)
    }
    
    public static func new(
        book: Book.State = .new()
    ) -> Self {
        .init(book: book, mode: .create)
    }
}
