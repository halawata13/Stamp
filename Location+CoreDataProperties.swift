//
//  Location+CoreDataProperties.swift
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var memo: String?
    @NSManaged public var id: UUID?
    @NSManaged public var date: NSDate?

}
