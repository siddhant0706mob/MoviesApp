//
//  BookmarkDataService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import CoreData

protocol BookmarkDataServiceProtocol {
    func addBookmark(_ id: Int)
    func deleteBookmark(_ id: Int)
    func isBookmarked(_ id: Int) -> Bool
    func getAllBookmarkedMovies() -> [Int]
}

class BookmarkDataService: BookmarkDataServiceProtocol {
    private let context: NSManagedObjectContext
    
    init() {
        self.context = DatabaseService.shared.persistentContainer.viewContext
    }
    
    func addBookmark(_ id: Int) {
        let entity = BookmarkEntity(context: context)
        entity.bookmarkedID = Int32(id)
        try? context.save()
    }
    
    func deleteBookmark(_ id: Int) {
        let request = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "bookmarkedID == %d", id)
        if let result = try? context.fetch(request),
           let obj = result.first {
            context.delete(obj)
            try? context.save()
        }
    }
    
    func isBookmarked(_ id: Int) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookmarkEntity")
        request.predicate = NSPredicate(format: "bookmarkedID == %d", id)
        request.fetchLimit = 1
        request.includesPropertyValues = false
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    func getAllBookmarkedMovies() -> [Int] {
        let request = BookmarkEntity.fetchRequest()
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["bookmarkedID"]
        
        if let results = try? context.fetch(request) as? [[String: Any]] {
            return results.compactMap { $0["bookmarkedID"] as? Int }
        }
        
        return []
    }
}
