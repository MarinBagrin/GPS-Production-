//
//  Tracker.swift
//  GPS
//
//  Created by Marin on 04.01.2025.
//
import UIKit
import CoreLocation
class Tracker {
    var lat: Double!
    var long: Double!
    var name: String!
    var id: Int!
    var battery: Int!
    var time: String!
    var address: String!
    var connectionGPS:Conection
    var connectionNET:Conection
    static var counts = 0
    init() {
        id = Tracker.counts
        connectionGPS = .missing
        connectionNET = .missing
        Tracker.counts += 1
        time = "2025/03/11 - 11:28"
        
    }
    func setAddress() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let address = """
                        Country: \(placemark.country ?? "Неизвестно"), City: \(placemark.locality ?? "Неизвестно"), Street: \(placemark.thoroughfare ?? "Неизвестно")
                        """
                self.address = address
            }
        }
    }
//    func setConfiguration(recTracker:tracker) {
//        lat = Double.random(in: 0...50)
//        long = Double.random(in: 0...50)
//        id = Tracker.counts
//        battery = Int(recTracker.battery)
//        name = recTracker.name
//        connectionGPS = .missing
//        connectionNET = .missing
//        time = "2025/03/11 - 11:28"
//    }

   
}
