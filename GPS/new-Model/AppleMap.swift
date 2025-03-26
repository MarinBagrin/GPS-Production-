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
    var trackers:[AnnotationTraker] = []
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
        for i in 0..<trackers.count {
            if (STServer.trackers[i].lat != 0 && STServer.trackers[i].long != 0) {
                mapView(map, viewFor: trackers[i])?.isHidden = true
                (mapView(map, viewFor: trackers[i]) as! TrackerAnnotationView).isHidden = true
                let tracker = STServer.trackers[i]
                trackers[i].coordinate = CLLocationCoordinate2D(latitude: tracker.lat, longitude: tracker.long)
                trackers[i].title = tracker.name
                trackers[i].subtitle = String(tracker.id)
                trackers[i].tracker = STServer.trackers[i]
            }
            else {
                mapView(map, viewFor: trackers[i])?.isHidden = false
            }
            
        }
    }
    func setCameraOnTracker(trackerShowMap: Tracker) {
        initialLocation = CLLocationCoordinate2D(latitude: trackerShowMap.lat, longitude: trackerShowMap.long)
        region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
        map.setRegion(region, animated: true)
        showMainView()
    }
    func updateSelfLocation(location:CLLocationCoordinate2D) {
        if !(map.annotations.last  is MKPointAnnotation) {
            map.addAnnotation(selfLoaction)
        }
        selfLoaction.coordinate = location
    }
    
    func checkAndAppendTrackers() {
        if (trackers.count == 0) {
            trackers = (0..<STServer.trackers.count).map{_ in AnnotationTraker()}
            trackers.forEach{ map.addAnnotation($0) }
        }
    }

    
    func stopUpdatingSelfLoaction() {
        map.removeAnnotation(selfLoaction)
    }

    func clearListAnnotations() {
        map.removeAnnotations(trackers)
        trackers.removeAll()
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
    var tracker:Tracker!
}

class TrackerAnnotationView: MKAnnotationView {
    lazy var titleLabel = UILabel()
    lazy var subtitleLabel = UILabel()
    var callout = CalloutView()
    var blurView = UIVisualEffectView()

     init(reuseIdentifier:String?) {
         super.init(annotation: nil, reuseIdentifier: reuseIdentifier)
         setupUI()
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCallout))
         self.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        callout.alpha = 0
        self.image = resizeImage(image: UIImage(named:"transportation-4.png")!, targetSize: CGSize(width: 40, height: 40))
        //titleLabel =  UILabel(frame: CGRect(x: frame.width * -2.5, y: frame.height + 2, width: frame.width * 6, height: 14))
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold) // шрифт 14, жирный
        titleLabel.textColor = .white // белый цвет текста
        titleLabel.textAlignment = .center // выравнивание по центру
        titleLabel.layer.shadowColor = UIColor.black.cgColor // белая тень
        titleLabel.layer.shadowOpacity = 0.85 // прозрачность тени
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2) // смещение тени
        titleLabel.layer.shadowRadius = 1 // радиус тени
        titleLabel.text = "amgpid"
        self.addSubview(blurView)
        self.addSubview(callout)
        self.addSubview(titleLabel)
        titleLabel.isHidden = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            titleLabel.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            callout.bottomAnchor.constraint(equalTo: self.topAnchor,constant: -2.5),
            callout.topAnchor.constraint(equalTo: self.topAnchor,constant: -230),
            callout.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: -115),
            callout.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 115),
        ])
        let blurEffect = UIBlurEffect(style: .extraLight) // .dark, .extraLight, .regular, .prominent
            
             // Создаем представление с этим эффектом
        
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = titleLabel.frame
        blurView.clipsToBounds = true
            
             // Добавляем размытие на фон
    }
    func setAnnotation(_ annotation:MKAnnotation) {
        titleLabel.text = (annotation as! AnnotationTraker ).title
        subtitleLabel.text = (annotation as! AnnotationTraker).subtitle

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showCallout() {
        self.callout.showHide()
        self.callout.updateData(tracker: (annotation as! AnnotationTraker).tracker)
    }
}
