//
//  Core Location.swift
//  GPS
//
//  Created by Marin on 08.01.2025.
//

import CoreLocation

class LocationData:NSObject, CLLocationManagerDelegate {
    static var shared = LocationData()
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdating() {
        locationManager.startUpdatingLocation()
    }
    func stoptLocationUpdating() {
        locationManager.stopUpdatingLocation()
        for map in mainView.listMaps.activeView.maps {
            map.stopUpdatingSelfLoaction()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        for map in mainView.listMaps.activeView.maps {
            map.updateSelfLocation(location: location2D)
        }
        print("i-1")
    }
    // Обработка ошибок
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error.localizedDescription)")
    }
}

