//
//  AppleMap.swift
//  GPS
//
//  Created by Marin on 30.12.2024.
//
import UIKit
import MapKit

class AppleMapMnagerView:NSObject/*, UIMap*/, MKMapViewDelegate {
    // Создаем экземпляр MKMapView
    let map: MKMapView
    var initialLocation: CLLocationCoordinate2D
    var region: MKCoordinateRegion
    var trackers:[AnnotationTraker] = []
    var selfLoaction = MKPointAnnotation()
    var viewModel: MapViewModelDelegate
    init(_ superFrame: CGRect, viewModel: MapViewModelDelegate) {
        map = MKMapView(frame:superFrame)
        initialLocation = CLLocationCoordinate2D(latitude: 47.003670, longitude: 28.907089)
        region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 1907, longitudinalMeters: 1907)
        map.setRegion(region, animated: true)
        self.viewModel = viewModel
        super.init()
        map.delegate = self
        bindViewModel()
    }
    private func bindViewModel() {
        viewModel.trackers.bind{ [weak self] trackers in
            self?.clearListAnnotations()
            self?.trackers = trackers.map{trackerViewModel in
                let annotationTracker = AnnotationTraker()
                trackerViewModel.bind{ [weak self] trackerViewModel in
                    self?.updateTracker(trackerAnnotation: annotationTracker, trackerViewModel: trackerViewModel)
                }
                return annotationTracker
            }
            if let tracckersAnnotations = self?.trackers {
                self?.map.addAnnotations(tracckersAnnotations)
                print("succesful")
            }
            else {
                print("not succseful")

            }
        }
        viewModel.positionCamera.bind{[weak self] positionCamera in
            guard let region = positionCamera else {
                return
            }
            self?.map.setRegion(region, animated: true)
        }//замыкание
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView:MKAnnotationView!
        if annotation is AnnotationTraker
        {
            let identifer = "annotationTracker"
            
            annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier:identifer)
            if (annotationView == nil) {
                annotationView = TrackerAnnotationView(reuseIdentifier: identifer)
                
            }
            (annotationView as! TrackerAnnotationView).configureAnnotation(annotation)
            
            annotationView.canShowCallout = false
            
        }
        return annotationView

    }
    private func updateTracker(trackerAnnotation: AnnotationTraker,trackerViewModel:TrackerViewModel) {
        trackerAnnotation.coordinate = CLLocationCoordinate2D(latitude: trackerViewModel.lat, longitude: trackerViewModel.long)
        trackerAnnotation.title = trackerViewModel.name
        trackerAnnotation.tracker = trackerViewModel
    }
    private func clearListAnnotations() {
        map.removeAnnotations(trackers)
        trackers.removeAll()
    }
    
//    func updateSelfLocation(location:CLLocationCoordinate2D) {
//        if !(map.annotations.last  is MKPointAnnotation) {
//            map.addAnnotation(selfLoaction)
//        }
//        selfLoaction.coordinate = location
//    }
    
//    func checkAndAppendTrackers() {
//        if (trackers.count == 0) {
//            trackers = (0..<STServer.trackers.count).map{_ in AnnotationTraker()}
//            trackers.forEach{ map.addAnnotation($0) }
//            print("закончилоась")
//        }
//    }

    
//    func stopUpdatingSelfLoaction() {
//        map.removeAnnotation(selfLoaction)
//    }

   
//    func getUIView() -> UIView {
//        return map
//    }
  
//    private func setSetingsSelfLocation() {
//        selfLoaction.title = "your location"
//        selfLoaction.subtitle = "your location"
//    }
}
class AnnotationTraker:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var title: String?
    var subtitle: String?
    var tracker:TrackerViewModel!
}

class TrackerAnnotationView: MKAnnotationView {
    var titleLabel = UILabel()
    var callout = CalloutView()
    var blurView = UIView()
    init(reuseIdentifier:String?) {
         super.init(annotation: nil, reuseIdentifier: reuseIdentifier)
         setupUI()
    }
    private func setupUI() {
        callout.alpha = 0
        self.image = resizeImage(image: UIImage(named:"transportation-4.png")!, targetSize: CGSize(width: 40, height: 40))
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold) // шрифт 14, жирный
        titleLabel.textColor = .white // белый цвет текста
        titleLabel.textAlignment = .center // выравнивание по центру
        titleLabel.layer.shadowColor = UIColor.black.cgColor // белая тень
        titleLabel.layer.shadowOpacity = 0.85 // прозрачность тени
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2) // смещение тени
        titleLabel.layer.shadowRadius = 1 // радиус тени
        
        titleLabel.isHidden = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addSubview(callout)
        //blurView.addSubview(titleLabel)
        blurView.backgroundColor = .red
             // Добавляем размытие на фон
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCallout))
        self.addGestureRecognizer(tapGesture)
    }
    func configureAnnotation(_ annotation:MKAnnotation) {
        titleLabel.text = (annotation as! AnnotationTraker ).title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = titleLabel.frame
    }
    @objc func showCallout() {
        self.callout.showHide()
        self.callout.updateData(tracker: (annotation as! AnnotationTraker).tracker)
    }
}

