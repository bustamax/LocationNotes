//
//  Folder+CoreDataProperties.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateUpdate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var note: NSSet?

}

// MARK: Generated accessors for note
extension Folder {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

extension Folder : Identifiable {

}
