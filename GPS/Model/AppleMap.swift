//
//  AppleMap.swift
//  GPS
//
//  Created by Marin on 30.12.2024.
//
import UIKit
import MapKit

class AppleMap:NSObject, UIMap, MKMapViewDelegate {
    // Создаем экземпляр MKMapView
    let map: MKMapView
    var initialLocation: CLLocationCoordinate2D
    var region: MKCoordinateRegion
    var trackers:[AnnotationTraker] = (0..<STServer.trackers.count).map{_ in AnnotationTraker()}
    var selfLoaction = MKPointAnnotation()
    
    init(_ superFrame: CGRect) {
        map = MKMapView(frame:superFrame)
        initialLocation = CLLocationCoordinate2D(latitude: 49, longitude: 27)
        region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1907, longitudinalMeters: 1907)
        map.setRegion(region, animated: true)
        super.init()
        trackers.forEach{ map.addAnnotation($0) }
//        map.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView:MKAnnotationView!
        if annotation is AnnotationTraker
        {
            let annotationTraker = annotation as! AnnotationTraker
            let identifer = "annotationTracker"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:identifer)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotationTraker,reuseIdentifier: identifer)
            }
            else {
                annotationView.annotation = annotationTraker
            }
            
            annotationView.image = resizeImage(image: UIImage(named:"tracking.png")!, targetSize: CGSize(width: 25, height: 25))
        }
        else {
            let identifer = "annotationSelf"
            let annotationSelf = annotation as! MKPointAnnotation
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotationSelf,reuseIdentifier: identifer)
            }
            else {
                annotationView.annotation = annotationSelf
            }
            annotationView.image = resizeImage(image: UIImage(named:"selfLocation.png")!, targetSize: CGSize(width: 25, height: 25))
        }
        annotationView.canShowCallout = true

        return annotationView
    }
    
    func updateTrackers() {
        for i in 0..<STServer.trackers.count {
            let tracker = STServer.trackers[i]
            trackers[i].coordinate = CLLocationCoordinate2D(latitude: tracker.lat, longitude: tracker.long)
            trackers[i].title = String(tracker.id)
            trackers[i].subtitle = tracker.name
            
        }
    }
    func setCameraOnTracker(trackerShowMap: Tracker) {
        initialLocation = CLLocationCoordinate2D(latitude: trackerShowMap.lat, longitude: trackerShowMap.long)
        region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        map.setRegion(region, animated: true)
    }
    func updateSelfLocation(location:CLLocationCoordinate2D) {
        if !(map.annotations.last  is MKPointAnnotation) {
            map.addAnnotation(selfLoaction)
        }
        selfLoaction.coordinate = location
    }
       
    func stopUpdatingSelfLoaction() {
        map.removeAnnotation(selfLoaction)
    }


    func getUIView() -> UIView {
        return map
    }
  
    private func setSetingsSelfLocation() {
        selfLoaction.title = "your location"
        selfLoaction.subtitle = "your location"
    }
}
class AnnotationTraker:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
}
