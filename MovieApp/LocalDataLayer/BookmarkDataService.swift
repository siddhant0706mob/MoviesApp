//
//  BookmarkDataService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import CoreData

protocol BookmarkDataServiceProtocol {
    func addBookmark(_ id: Int, completion: (() -> Void)?)
    func deleteBookmark(_ id: Int, completion: (() -> Void)?)
    func isBookmarked(_ id: Int, completion: @escaping (Bool) -> Void)
    func getAllBookmarkedMovies(completion: @escaping ([Int]) -> Void)
}

class BookmarkDataService: BookmarkDataServiceProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = DatabaseService.shared.persistentContainer) {
        self.container = container
    }

    func addBookmark(_ id: Int, completion: (() -> Void)? = nil) {
        let bgContext = container.newBackgroundContext()
        bgContext.perform {
            let entity = BookmarkEntity(context: bgContext)
            entity.bookmarkedID = Int32(id)
            do {
                try bgContext.save()
                DispatchQueue.main.async { completion?() }
            } catch {
                print("Add Bookmark Save Error:", error)
                DispatchQueue.main.async { completion?() }
            }
        }
    }

    func deleteBookmark(_ id: Int, completion: (() -> Void)? = nil) {
        let bgContext = container.newBackgroundContext()
        bgContext.perform {
            let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "bookmarkedID == %d", id)
            do {
                let result = try bgContext.fetch(request)
                if let obj = result.first {
                    bgContext.delete(obj)
                    try bgContext.save()
                }
                DispatchQueue.main.async { completion?() }
            } catch {
                print("Delete Bookmark Error:", error)
                DispatchQueue.main.async { completion?() }
            }
        }
    }

    func isBookmarked(_ id: Int, completion: @escaping (Bool) -> Void) {
        let bgContext = container.newBackgroundContext()
        bgContext.perform {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BookmarkEntity")
            request.predicate = NSPredicate(format: "bookmarkedID == %d", id)
            request.fetchLimit = 1
            request.includesPropertyValues = false
            do {
                let count = try bgContext.count(for: request)
                DispatchQueue.main.async { completion(count > 0) }
            } catch {
                print("isBookmarked Error:", error)
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    func getAllBookmarkedMovies(completion: @escaping ([Int]) -> Void) {
        let bgContext = container.newBackgroundContext()
        bgContext.perform {
            let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
            do {
                let results = try bgContext.fetch(request)
                let ids = results.map { Int($0.bookmarkedID) }
                DispatchQueue.main.async { completion(Array(Set(ids))) }
            } catch {
                print("GetAllBookmarked Error:", error)
                DispatchQueue.main.async { completion([]) }
            }
        }
    }
}
