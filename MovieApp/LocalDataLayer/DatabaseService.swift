//
//  BookMarkService.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//

import CoreData

class DatabaseService {
    static let shared = DatabaseService()
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MovieApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading store failed: \(error)")
            }
        }
    }
    
}
