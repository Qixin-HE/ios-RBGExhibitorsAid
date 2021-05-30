//
//  Plant+CoreDataProperties.swift
//  29217814-a1
//
//  Created by Zoe on 21/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var family: String?
    @NSManaged public var img: String?
    @NSManaged public var name: String?
    @NSManaged public var plantDescription: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var year: String?
    @NSManaged public var exhibitions: NSSet?

}

// MARK: Generated accessors for exhibitions
extension Plant {

    @objc(addExhibitionsObject:)
    @NSManaged public func addToExhibitions(_ value: Exhibition)

    @objc(removeExhibitionsObject:)
    @NSManaged public func removeFromExhibitions(_ value: Exhibition)

    @objc(addExhibitions:)
    @NSManaged public func addToExhibitions(_ values: NSSet)

    @objc(removeExhibitions:)
    @NSManaged public func removeFromExhibitions(_ values: NSSet)

}
