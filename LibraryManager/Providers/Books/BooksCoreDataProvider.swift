//
//  CoreDataProvider.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 05.05.23.
//

import CoreData
import Foundation

// MARK: - Books Core Data Provider
public class BooksCoreDataProvider: BooksProvider {
    public static let shared: BooksCoreDataProvider = .init()
    private let container: NSPersistentContainer = NSPersistentContainer(name: containerName)

    // MARK: private consts
    private static let containerName: String = "Library"
    
    // MARK: init
    private init() {
        container.loadPersistentStores { description, error in
            if error != nil {
                print("Error occured while loading store: \(description)")
            }
        }
    }
    
    public func fetchAllBooks() -> [BookRowReducer.State] {
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(BookEntity.author), ascending: true)]
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
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try container.viewContext.fetch(fetchRequest).first
    }
}
