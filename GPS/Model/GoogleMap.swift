//
//  GoogleMap.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//
import UIKit
import GoogleMaps
import MapKit



class GoogleMap: UIMap {
    var camera = GMSCameraPosition.camera(withLatitude: 49, longitude: 27, zoom: 21)
    var map = GMSMapView()
    lazy var trackers:[GMSMarker] = (0..<STServer.trackers.count).map{_ in
        var mark = GMSMarker()
        mark.icon = resizeImage(image:UIImage(named: "tracking.png")!,targetSize: CGSize(width:25,height:25))
        mark.map = map
        return mark
    }
    var selfLocation =  GMSMarker()
    func getUIView() -> UIView {
        return map
    }
    
 
    func updateTrackers() {
        for i in 0..<STServer.trackers.count {
            let tracker = STServer.trackers[i]
            trackers[i].position = CLLocationCoordinate2D(latitude:Double(tracker.lat), longitude:Double(tracker.long))
            trackers[i].title = String(tracker.id)
            trackers[i].snippet = tracker.name
        }
    }
    func setCameraOnTracker(trackerShowMap: Tracker) {
        camera = GMSCameraPosition.camera(withLatitude:trackerShowMap.lat , longitude: trackerShowMap.long, zoom: 10)
        map.camera = camera
        
    }
    func updateSelfLocation(location:CLLocationCoordinate2D) {
        selfLocation.position = location
        selfLocation.map = map
    }
    func stopUpdatingSelfLoaction() {
        selfLocation.map = nil
    }
    
    init(_ superFrame: CGRect) {
        let childFrame = CGRect(x: 0, y: 0, width: superFrame.width, height: superFrame.height-48)
        map.camera = self.camera
        map.frame = childFrame
        self.setSetingsSelfLocation()
    }
    
    private func setSetingsSelfLocation() {
        selfLocation.title = "your location"
        selfLocation.icon = resizeImage(image: UIImage(named:"selfLocation.png")!, targetSize: CGSize(width: 35, height: 35))
    }

}
