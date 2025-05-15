import UIKit
import CoreLocation


   





class TrackerModel {
    var lat: Double = 0
    var long: Double = 0
    var latcash:Double = 0
    var longcash:Double = 0
    var name: String!
    var id: Int!
    var battery: Int!
    var time: String!
    var speed: Int!
    var address: String!
    var connectionGPS:Conection
    var connectionNET:Conection
    static var counts = 0
    init() {
        id = TrackerModel.counts
        connectionGPS = .stable
        connectionNET = .stable
        TrackerModel.counts += 1
        time = "2025/03/11 - 11:28"
        
    }
    func setAddress() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        var locale:Locale!
        switch(lang) {
        case .ru:
            locale = Locale(identifier: "ru_RU")  // для русского языка
        case .ro:
            locale = Locale(identifier: "ro_RO")  // для румынского языка
        case .eng:
            locale = Locale(identifier: "en_US")  // для английского языка
        }
        if (lat != latcash || long != longcash)
        {

            geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { (placemarks, error) in
                if let error = error {
                    print("Ошибка1: \(error.localizedDescription)")
                    self.address = "error"
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
    }
}

//import CoreLocation
//
//class LocationData:NSObject, CLLocationManagerDelegate {
//    static var shared = LocationData()
//    
//    var locationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//    }
//    
//    func startLocationUpdating() {
//        locationManager.startUpdatingLocation()
//    }
//    func stoptLocationUpdating() {
//        locationManager.stopUpdatingLocation()
//        for map in mainView.listMaps.activeView.maps {
//            map.stopUpdatingSelfLoaction()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let location2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        for map in mainView.listMaps.activeView.maps {
//            map.updateSelfLocation(location: location2D)
//        }
//        print("i-1")
//    }
//    // Обработка ошибок
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Ошибка: \(error.localizedDescription)")
//    }
//}
