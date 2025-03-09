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
        map.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView:MKAnnotationView!
        if annotation is AnnotationTraker
        {
            let annotationTraker = annotation as! AnnotationTraker
            let identifer = "annotationTracker"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:identifer)
            if annotationView == nil {
                annotationView = TrackerAnnotationView(reuseIdentifier: identifer)
                (annotationView as! TrackerAnnotationView).setAnnotation(annotationTraker)
            }
            else {
                (annotationView as! TrackerAnnotationView).setAnnotation(annotationTraker)
            }
            
        }
//        else {
//            let identifer = "annotationSelf"
//            let annotationSelf = annotation as! MKPointAnnotation
//            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
//            if annotationView == nil {
//                annotationView = MKAnnotationView(annotation: annotationSelf,reuseIdentifier: identifer)
//            }
//            else {
//                print("2 != nil")
//                annotationView.annotation = annotationSelf
//            }
//        }
        annotationView.canShowCallout = false

        return annotationView
    }
    
    func updateTrackers() {
        for i in 0..<STServer.trackers.count {
            let tracker = STServer.trackers[i]
            trackers[i].coordinate = CLLocationCoordinate2D(latitude: tracker.lat, longitude: tracker.long)
            trackers[i].title = tracker.name
            
            trackers[i].subtitle = String(tracker.id)
            
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

class TrackerAnnotationView: MKAnnotationView {
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    
     init(reuseIdentifier:String?) {
        super.init(annotation: nil, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named:"tracking.png")!, targetSize: CGSize(width: 25, height: 25))
        titleLabel =  UILabel(frame: CGRect(x: frame.width * -2.5, y: frame.height + 2, width: frame.width * 6, height: 14))
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold) // шрифт 14, жирный
        titleLabel.textColor = .systemGray6 // белый цвет текста
        titleLabel.textAlignment = .center // выравнивание по центру
        titleLabel.layer.shadowColor = UIColor.white.cgColor // черная тень
        titleLabel.layer.shadowOpacity = 0.5 // прозрачность тени
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2) // смещение тени
        titleLabel.layer.shadowRadius = 3 // радиус тени
        //subtitleLabel = UILabel(frame: CGRect(x: frame.width * -3, y: frame.height + 16, width: frame.width * 6, height: 14))
        self.addSubview(titleLabel)
        //self.addSubview(subtitleLabel)
    }
    func setAnnotation(_ annotation:MKAnnotation) {
        titleLabel.text = (annotation as! AnnotationTraker ).title
        subtitleLabel.text = (annotation as! AnnotationTraker).subtitle
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
