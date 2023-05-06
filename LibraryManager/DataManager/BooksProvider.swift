//
//  BooksProvider.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 06.05.23.
//

import Foundation

// MARK: Books Provider Protocol
public protocol BooksProvider {
    func fetchAllBooks() -> [Book.State]
    func addNewBook(_ newBook: Book.State)
    func updateBook(_ book: Book.State)
    func removeBook(_ book: Book.State)
}
