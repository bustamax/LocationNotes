//
//  ImageNote+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//
//

import Foundation
import CoreData


extension ImageNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageNote> {
        return NSFetchRequest<ImageNote>(entityName: "ImageNote")
    }

    @NSManaged public var imageBig: Data?
    @NSManaged public var note: Note?

}

extension ImageNote : Identifiable {

}
