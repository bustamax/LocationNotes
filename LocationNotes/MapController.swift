//
//  MapController.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 17.10.2022.
//

import UIKit
import MapKit

class MapController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        mapView.removeAnnotations(mapView.annotations)
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
              
            }
        }
    }



}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
       let pin =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        var actualNote = (view.annotation as! NoteAnnotation).note
        let nc = storyboard?.instantiateViewController(withIdentifier: "noteSID") as! NoteController
        nc.note = actualNote
        navigationController?.pushViewController(nc, animated: true)
      //  present(nc, animated: true)
    }
}
