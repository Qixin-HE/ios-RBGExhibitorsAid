//
//  Exhibition+CoreDataProperties.swift
//  29217814-a1
//
//  Created by Zoe on 21/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//
//

import Foundation
import CoreData


extension Exhibition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exhibition> {
        return NSFetchRequest<Exhibition>(entityName: "Exhibition")
    }

    @NSManaged public var exhibitionDescription: String?
    @NSManaged public var img: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String?
    @NSManaged public var plants: NSSet?

}

// MARK: Generated accessors for plants
extension Exhibition {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: Plant)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: Plant)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: NSSet)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: NSSet)

}
