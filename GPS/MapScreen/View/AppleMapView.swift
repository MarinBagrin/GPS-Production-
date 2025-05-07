//
//  AppleMap.swift
//  GPS
//
//  Created by Marin on 30.12.2024.
//
import UIKit
import Combine
import MapKit
import CoreLocation

class AppleMapMnagerView:NSObject/*, UIMap*/, MKMapViewDelegate {
    // Создаем экземпляр MKMapView
    let map: MKMapView
    var initialLocation: CLLocationCoordinate2D
    var region: MKCoordinateRegion
    var trackers:[AnnotationTraker] = []
    var archiveAnnotations:[MKAnnotation] = []
    var archiveTrackers:[TrackerViewModel] = []
    var selfLoaction = MKPointAnnotation()
    var viewModel: MapViewModel
    var routePolyline:MKPolyline?
    var cancellabels = Set<AnyCancellable>()
    init(_ superFrame: CGRect, viewModel: MapViewModel) {
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
            }
        }
        
        viewModel.$stateShowing.combineLatest(viewModel.$archiveTrackers)
            .receive(on:  RunLoop.main)
            .sink{[weak self] stateShowing,archiveTrackers in
                self?.archiveTrackers = archiveTrackers
                print("state showing: ", stateShowing)
                print("archiveTrackers: ", archiveTrackers.count)
                if stateShowing == .archive && !archiveTrackers.isEmpty {
                    print("drawRoute")
                    self?.drawRoute()
                }
                else {
                    if let routePolyline = self?.routePolyline {
                        self?.map.removeOverlay(routePolyline)
                    }
                }
            }
            .store(in: &cancellabels)
        
        viewModel.positionCamera.bind{[weak self] positionCamera in
            guard let region = positionCamera else {
                return
            }
            self?.map.setRegion(region, animated: true)
            
        }//замыкание
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Убедимся, что это наша полилиния
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Настраиваем внешний вид линии
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 4               // толщина линии
        renderer.strokeColor = .systemBlue   // цвет линии
        renderer.lineJoin = .bevel          // сглаженные стыки
        
        return renderer
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
    
    private func drawRoute() {
        
        func distanceInMeters(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D) -> Double {
            let loc1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let loc2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
            let meters = loc1.distance(from: loc2)
            return Double(meters)
        }
        func strToDate(str:String) -> Date? {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "HH:mm:ss"
            return formatter.date(from: str)
            
        }
        func checkValidityDriving(arrTM: inout [TrackerMap],arrCC: inout [CLLocationCoordinate2D]) {
            for i in 0..<arrTM.count {
                if arrTM[i].state == .driving {
                    var validLeft = false
                    var validLRight = false
                    if i - 1 >= 0 && arrTM[i-1].state == .driving {
                        validLeft = true
                    }
                    if i + 1 < arrTM.count && arrTM[i+1].state == .driving {
                        validLRight = true
                    }
                    if validLeft || validLRight {
                        arrTM[i].state = .driving
                        archiveAnnotations.append(AnnotationDrivinf())
                    }
                }
            }
        }
        func compressAndCheckValidityParkeds(arrTM: inout [TrackerMap],arrCC: inout [CLLocationCoordinate2D]) {
            for i in 0..<arrTM.count {
                var intervalBetweenParkeds = TimeInterval(0)
                if arrTM[i].state == .parking {
                    
                    for j in i..<arrTM.count {
                        
                        if i == j {continue}
                        if arrTM[j].state == .driving {
                            
                            if intervalBetweenParkeds > 50 && intervalBetweenParkeds < 300 {
    
                                arrTM[i].state = .stoping
                            }
                            else if intervalBetweenParkeds > 300 {
                                
                                arrTM[i].state = .parking
                            }
                            break
                        }
                        intervalBetweenParkeds += arrTM[j-1].time.timeIntervalSince(arrTM[j].time)
                        arrTM[j].state = .trash
                        
                    }
                }
            }
            
            
            var coordinates:[CLLocationCoordinate2D] = []
            var statingTrackers:[TrackerMap] = []
            
            var last = CLLocationCoordinate2D(latitude: viewModel.archiveTrackers[0].lat, longitude: viewModel.archiveTrackers[0].long)
            
            
            
            for i in 0..<viewModel.archiveTrackers.count {//фильтрация данных
                let tracker = viewModel.archiveTrackers[i]
                
                if tracker.lat == 0 || tracker.long == 0  {print("zalupazalupazalupazalupazalupazalupazalupazalupazalupazalupazalupa");continue}
                if abs(Double(last.latitude + last.longitude) - (tracker.lat + tracker.long)) > 0.5{print("belicbelicbelicbelicbelic");continue}
                
                let current =  CLLocationCoordinate2D(latitude: tracker.lat, longitude: tracker.long)
                let meters = distanceInMeters(from: last, to: current)
                print("meters:", meters.rounded(), "speed: \(tracker.speed)km/h;", "time:",tracker.time, "lat:\(tracker.long); long:\(tracker.lat)")
                
                if meters >= 10 || tracker.speed > 0 {
                    statingTrackers.append(TrackerMap(coordinates: current, meters: Int(meters), state: .driving,time: strToDate(str: tracker.time)))
                }
                else {
                    statingTrackers.append(TrackerMap(coordinates: current, meters: Int(meters), state: .stoping,time: strToDate(str: tracker.time)))
                }
                checkValidityDriving(arrTM: &statingTrackers, arrCC: &coordinates)
            }
            
            
            
            
            
            
            
            print("После фильтрации:")
            print("Мин. широта:", coordinates.map{$0.latitude}.min()!)
            print("Макс. широта:", coordinates.map{$0.latitude}.max()!)
            print("Мин. долгота:", coordinates.map{$0.longitude}.min()!)
            print("Макс. долгота:", coordinates.map{$0.longitude}.max()!)
            print("count coordinates:", coordinates.count)
            print("count annotations:", trackers.count)
            
            routePolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            
            
            guard let routePolyline = routePolyline else {return}
            
            map.addOverlay(routePolyline)
            map.setVisibleMapRect(routePolyline.boundingMapRect, edgePadding: .init(top: 50, left: 50, bottom: 50, right: 50), animated: true)
            self.map.addAnnotations(trackers)
            
        }
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
    
    
}


class TrackerMap {
    var coordinates:CLLocationCoordinate2D
    var meters:Int
    var state:StateTracker
    var time:Date
    init(coordinates:CLLocationCoordinate2D,meters:Int,state:StateTracker,time:Date?) {
        self.coordinates = coordinates
        self.meters = meters
        self.state = state
        guard let date = time else {print("AMP code 0");self.time = .distantPast;return}
        self.time = date
    }
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
func bearing(from: CLLocationCoordinate2D,
             to:   CLLocationCoordinate2D) -> CLLocationDirection {
    // 1. Переводим в радианы
    let φ1 = from.latitude  * .pi / 180
    let λ1 = from.longitude * .pi / 180
    let φ2 = to.latitude    * .pi / 180
    let λ2 = to.longitude   * .pi / 180

    // 2. Разница долгот
    let Δλ = λ2 - λ1

    // 3. Расчёт x и y
    let y = sin(Δλ) * cos(φ2)
    let x = cos(φ1)*sin(φ2)
           - sin(φ1)*cos(φ2)*cos(Δλ)

    // 4. Угол в радианах
    var θ = atan2(y, x)

    // 5. Перевод в градусы и нормализация
    θ = θ * 180 / .pi           // в градусы
    let degrees = fmod(θ + 360, 360)  // [0…360)
    let radians = degrees * .pi / 180
    return radians
}


class AnnotationStationare:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerViewModel!
}
class AnnotationParked:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerViewModel!
}
class AnnotationDrivinf:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerViewModel!
}

enum StateTracker {
    case parking, driving, stoping, trash
}
