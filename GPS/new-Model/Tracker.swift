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
        lat = Double.random(in: -10...30)
        long = Double.random(in: 0...50)
        id = Tracker.counts
        battery = Int.random(in: 10...85)
        let names:[String] = ["BMW m5","AMG","AUDI","OPEL","LADA","VOLVO","Subaru"]
        name = names[Int.random(in: 0..<names.count)]
        connectionGPS = .missing
        connectionNET = .missing
        Tracker.counts += 1
        time = "2025/03/11 - 11:28"
        //setAddress()
        
        print(name! + " create")
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
                        Country: \(placemark.country ?? "Неизвестно") City: \(placemark.locality ?? "Неизвестно")Street: \(placemark.thoroughfare ?? "Неизвестно")
                        """
                self.address = address
            }
        }
    }

   
}
