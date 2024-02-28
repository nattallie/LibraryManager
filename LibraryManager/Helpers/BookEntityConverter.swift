//
//  BookEntityConverter.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 06.05.23.
//

import Foundation

// MARK: - Book.State from BookEntity
extension BookRowReducer.State {
    public static func from(_ entity: BookEntity) -> Self {
        .init(
            id: entity.id!,
            title: entity.title ?? "",
            author: entity.author ?? "",
            owns: entity.owns,
            wantsToBuy: entity.wantsToBuy,
            wantsToRead: entity.wantsToRead,
            isRead: entity.isRead
        )
    }
}

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
