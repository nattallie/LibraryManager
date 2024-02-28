//
//  BooksTestProvider.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 06.05.23.
//

import CoreData
import Foundation

// MARK: - Books Test Provider
public class BooksTestProvider: BooksProvider {
    public static let shared: BooksTestProvider = .init()
    private let container: NSPersistentContainer

    // MARK: private consts
    private static let containerName: String = "Library"
    private static let entityName: String = "BookEntity"

    private init() {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container = NSPersistentContainer(name: BooksTestProvider.containerName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if error != nil {
                print("Error occured while loading store: \(description)")
            }
        }
    }

    public func fetchAllBooks() -> [BookRowReducer.State] {
        let request: NSFetchRequest<BookEntity> = .init(entityName: BooksTestProvider.entityName)
        do {
            let books = try container.viewContext.fetch(request)
            return books.compactMap { BookRowReducer.State.from($0) }
        } catch {
            print("Error occured while fetching books", error)
            return []
        }
    }

    public func addNewBook(_ newBook: BookRowReducer.State) {
        let bookEntity: BookEntity = .init(context: container.viewContext)
        bookEntity.from(newBook)
        container.viewContext.insert(bookEntity)

        do {
            try container.viewContext.save()
        } catch {
            print("Error occured while saving new book", error)
        }
    }

    public func updateBook(_ book: BookRowReducer.State) {
        do {
            guard let oldBook = try fetchBookEntityWith(id: book.id) else { return }
            oldBook.from(book)
            try container.viewContext.save()
        } catch {
            print("Error occured while updating existing book", error)
        }
    }

    public func removeBook(_ book: BookRowReducer.State) {
        do {
            guard let oldBook = try fetchBookEntityWith(id: book.id) else { return }
            container.viewContext.delete(oldBook)
            try container.viewContext.save()
        } catch {
            print("Error occured while deleting book", error)
        }
    }

    private func fetchBookEntityWith(id: UUID) throws -> BookEntity? {
        let fetchRequest = NSFetchRequest<BookEntity>(entityName: BooksTestProvider.entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try container.viewContext.fetch(fetchRequest).first
    }
}
