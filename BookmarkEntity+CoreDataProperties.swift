//
//  BookmarkEntity+CoreDataProperties.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//
//

import Foundation
import CoreData


extension BookmarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }

    @NSManaged public var bookmarkedID: Int32

}

extension BookmarkEntity : Identifiable {

}
