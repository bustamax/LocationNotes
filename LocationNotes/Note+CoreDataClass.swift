//
//  Note+CoreDataClass.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 06.10.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {
    class func newNote(name:String, infolder:Folder?) -> Note{
        let note = Note(context: CoreDataManager.sharedInstance.managedContext)
        
        note.name = name
        note.dateUpdate = Date()
        if let infolder = infolder{
            note.folder = infolder}
        return note
    }
    var imageActual:UIImage?{
        set{
            if newValue == nil {
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedContext.delete(self.image!)
                }
                self.imageSmall == nil
            }else{
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedContext)
                }
             
                    self.image?.imageBig = newValue!.jpegData(compressionQuality: 1) as Data?
                self.imageSmall = newValue!.jpegData(compressionQuality: 0.05) as Data?
                
            }
            dateUpdate = Date()
        }
        get{
            if self.image != nil{
                if self.image?.imageBig != nil{
                    return  UIImage(data: self.image!.imageBig! as Data)
                    
                }
                
            }
            return nil
        }
    }
    //установка локации для заметки
    var locationActual: LocationCoordinate?{
        
        get{
            if self.location == nil {
                return nil
            }else{
                return LocationCoordinate(lat: self.location!.lat, lon: self.location!.lon)
            }
            
        }
        set{
            if newValue == nil && self.location != nil{
                // удалить локацию
                CoreDataManager.sharedInstance.managedContext.delete(location!)
            }
            if newValue != nil && self.location != nil{
                // обновить локацию
                self.location!.lat = newValue!.lat
                self.location!.lon = newValue!.lon
            }
            if newValue != nil && self.location == nil{
                // создать локацию
                let newlocation = Location(context: CoreDataManager.sharedInstance.managedContext)
                newlocation.lon = newValue!.lon
                newlocation.lat = newValue!.lat
                self.location = newlocation
               
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.sharedInstace.getCurrentLocation { (location) in
            self.locationActual = location
        }
    }
    
    func addImage(image: UIImage){
       let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedContext)
        imageNote.imageBig = image.jpegData(compressionQuality: 1) as Data?
        self.image = imageNote
    }
    
    func addLocation(lat: Double, lon: Double){
        let location = Location(context: CoreDataManager.sharedInstance.managedContext)
        location.lat = lat
        location.lon = lon
        self.location = location
        
    }
    
    var dateUpdateString: String{
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: self.dateUpdate as! Date)
    }
    
}
