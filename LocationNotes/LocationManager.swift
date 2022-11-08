//
//  LocationManager.swift
//  LocationNotes
//
//  Created by Максим Юрисов on 16.10.2022.
//

import UIKit
import CoreLocation

struct LocationCoordinate{
    var lat: Double
    var lon: Double
    
    static func create (location: CLLocation)-> LocationCoordinate{
        return LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstace = LocationManager()
    
    var manager = CLLocationManager()
    
    func requestAutorization(){
        manager.requestWhenInUseAuthorization()
    }
    var blockForSave: ((LocationCoordinate)->Void)?
    func getCurrentLocation(block: ((LocationCoordinate)->Void)?) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            print("User abort location permission")
            return
        }
        
        blockForSave = block
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
       let lc = LocationCoordinate.create(location: locations.last!)
        blockForSave?(lc)
        
        manager.stopUpdatingLocation()
    }
}
