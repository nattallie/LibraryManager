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
    static func mock(
        currentSegment: BookSegment =  .library,
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
        ]
    ) -> Self {
        .init(
            currentSegment: currentSegment,
            books: books,
            newBook: .new()
        )
    }
}

// MARK: - Book.State
extension Book.State {
    static func mock(
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
}

// MARK: - BookDetails.State
extension BookDetails.State {
    static func mock(
        book: Book.State = .mock()
    ) -> Self {
        .init(book: book, mode: .edit)
    }
    
    static func new() -> Self {
        .init(book: .init(id: UUID(), title: "", author: "", owns: false, wantsToBuy: false, wantsToRead: false, isRead: false), mode: .create)
    }
}
