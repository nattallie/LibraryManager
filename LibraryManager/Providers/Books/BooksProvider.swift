//
//  BooksProvider.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 06.05.23.
//

import Foundation

// MARK: Books Provider Protocol
public protocol BooksProvider {
    func fetchAllBooks() -> [BookRowReducer.State]
    func addNewBook(_ newBook: BookRowReducer.State)
    func updateBook(_ book: BookRowReducer.State)
    func removeBook(_ book: BookRowReducer.State)
}
