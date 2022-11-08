//
//  Folder+CoreDataClass.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    class func newFolder(name:String) -> Folder{
        let folder = Folder(context: CoreDataManager.sharedInstance.managedContext)
        folder.name = name
        folder.dateUpdate = Date()
        return folder
    }
    
    func addNotetoFolder()->Note{
        let note = Note(context: CoreDataManager.sharedInstance.managedContext)
        
        note.folder = self
        note.dateUpdate = Date()
        return note
    }
    
    var notesSorted: [Note]{
        let sortDesc = NSSortDescriptor(key: "dateUpdate", ascending: false)
        return self.note?.sortedArray(using: [sortDesc]) as! [Note]
    }
    
}
