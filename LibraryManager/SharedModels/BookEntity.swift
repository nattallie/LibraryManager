//
//  BookEntity.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 29.02.24.
//

import Foundation

// MARK: - BookEntity from Book.State
extension BookEntity {
    public func from(_ book: BookRowReducer.State) {
        self.id = book.id
        self.title = book.title
        self.author = book.author
        self.owns = book.owns
        self.wantsToBuy = book.wantsToBuy
        self.wantsToRead = book.wantsToRead
        self.isRead = book.isRead
    }
}
