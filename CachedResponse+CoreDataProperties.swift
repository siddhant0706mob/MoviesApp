//
//  CachedResponse+CoreDataProperties.swift
//  MovieApp
//
//  Created by Siddhant Ranjan on 15/07/25.
//
//

import Foundation
import CoreData


extension CachedResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedResponse> {
        return NSFetchRequest<CachedResponse>(entityName: "CachedResponse")
    }

    @NSManaged public var key: String?
    @NSManaged public var data: String?
    @NSManaged public var addedOn: Date?

}

extension CachedResponse : Identifiable {

}
