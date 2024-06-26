//
//  BooksClient.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 05.05.23.
//

import ComposableArchitecture
import Foundation

// MARK: - Books Client
public struct BooksClient: DependencyKey {
    public var provider: BooksProvider
    
    public static var liveValue: BooksClient = .init(provider: BooksCoreDataProvider.shared)
    public static var testValue: BooksClient = .init(provider: BooksTestProvider.shared)
    public static var previewValue: BooksClient = .init(provider: BooksTestProvider.shared)
}

extension DependencyValues {
    public var booksClient: BooksClient {
        get { self[BooksClient.self] }
        set { self[BooksClient.self] = newValue }
    }
}
