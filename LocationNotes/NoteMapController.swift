//
//  NoteMapController.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 17.10.2022.
//

import UIKit
import MapKit

class NoteAnnotation:NSObject, MKAnnotation{
    var note:Note
    var coordinate: CLLocationCoordinate2D
    
    // Title and subtitle for use by selection UI.
    var title: String?

    var subtitle: String?
    
    init(note:Note){
        self.note = note
        if note.location != nil{
            coordinate = CLLocationCoordinate2D(latitude: note.location!.lat, longitude: note.location!.lon)}
        else{
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
        }
        self.title = note.name
        self.subtitle = note.textDescription
    }
    
}

class NoteMapController: UIViewController {

    var note: Note?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        if note?.locationActual != nil {
            mapView.addAnnotation(NoteAnnotation(note: note!))
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: note!.locationActual!.lat, longitude: note!.locationActual!.lon)
        }
        
       var ltgr =  UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [ltgr]
        
    }
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began{
            return
        }
        let point = recognizer.location(in: mapView)
        // сопоставляем точку тапа с точкой на мэп вью
        let c = mapView.convert(point, toCoordinateFrom: mapView)
        var newLocation = LocationCoordinate(lat: c.latitude, lon: c.longitude)
        note?.locationActual = newLocation
        CoreDataManager.sharedInstance.saveContext()
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(NoteAnnotation(note: note!))
    }
    


}
extension NoteMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
       let pin =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        return pin
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState){
        
        if newState == .ending{
            var newlocation = LocationCoordinate(lat: (view.annotation?.coordinate.latitude)!, lon: (view.annotation?.coordinate.longitude)!)
            note?.locationActual = newlocation
            CoreDataManager.sharedInstance.saveContext()
            
        }
    }
}
