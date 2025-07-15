//
//  CachingService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import CoreData
import UIKit

protocol LocalDataProviderProtocol: AnyObject {
    func getResponse(for key: String, completion: @escaping (String?) -> Void)
    func saveResponse(for key: String, data: String)
}

final class CachingService: LocalDataProviderProtocol {

    static let shared = CachingService()
    private let backgroundContext: NSManagedObjectContext

    private init() {
        backgroundContext = DatabaseService.shared.persistentContainer.newBackgroundContext()
    }

    func saveResponse(for key: String, data: String) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedResponse> = CachedResponse.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "key == %@", key)

            if let existing = try? self.backgroundContext.fetch(fetchRequest).first {
                self.backgroundContext.delete(existing)
            }

            let cacheItem = CachedResponse(context: self.backgroundContext)
            cacheItem.key = key
            cacheItem.data = data
            cacheItem.addedOn = Date()

            do {
                try self.backgroundContext.save()
            } catch {
            }
        }
    }

    func getResponse(for key: String, completion: @escaping (String?) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedResponse> = CachedResponse.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "key == %@", key)
            fetchRequest.fetchLimit = 1

            let result = try? self.backgroundContext.fetch(fetchRequest).first
            completion(result?.data)
        }
    }

    func clearCache(olderThan days: Int = 7) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<CachedResponse> = CachedResponse.fetchRequest()
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
            fetchRequest.predicate = NSPredicate(format: "addedOn < %@", cutoffDate as NSDate)

            if let oldItems = try? self.backgroundContext.fetch(fetchRequest) {
                oldItems.forEach { self.backgroundContext.delete($0) }
                do {
                    try self.backgroundContext.save()
                } catch {
                }
            }
        }
    }
}
