//
//  Location+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var note: Note?

}

extension Location : Identifiable {

}
