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
    var routesPolyline = [MKPolyline]()
    var headingObserver: NSKeyValueObservation?
    var displayLink: CADisplayLink?
    
    
    @Published var angleCamera = Double(0)
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
        viewModel.trackers.bind{ [] trackers in
            self.clearListAnnotations()
            
            if self.viewModel.stateShowing == .archive {return}
            self.trackers = trackers.map{trackerViewModel in
                let annotationTracker = AnnotationTraker()
                trackerViewModel.bind{ [weak self] trackerViewModel in
                    self?.updateTracker(trackerAnnotation: annotationTracker, trackerViewModel: trackerViewModel)
                }
                return annotationTracker
            }
            
            self.map.addAnnotations(self.trackers)
            
        }
        
        Publishers.CombineLatest3(viewModel.$stateShowing,viewModel.$archiveTrackers,viewModel.$countArchives)
            .receive(on:  RunLoop.main)
            .sink{[weak self] stateShowing,archiveTrackers,indexArchive in
                //print(stateShowing, archiveTrackers.count, indexArchive)
                if archiveTrackers.count == 0 || archiveTrackers.count <= indexArchive  {          print("archiveTrackers что то с индексом");return}
                self?.archiveTrackers = archiveTrackers[indexArchive]
                print("state showing: ", stateShowing)
                print("archiveTrackers: ", archiveTrackers.count)
                if stateShowing == .archive && !archiveTrackers[indexArchive].isEmpty {
                    print("drawRoute")
                    self?.drawRoute(for:archiveTrackers[indexArchive])
                }
                else {
                    
                    self?.map.removeOverlays(self?.routesPolyline ?? [])
                    //self?.map.undoManager?.removeAllActions()
                    self?.map.removeAnnotations(self?.archiveAnnotations ?? [])
                    self?.archiveAnnotations.removeAll()
                }
            }
            .store(in: &cancellabels)
        
        viewModel.positionCamera.bind{[weak self] positionCamera in
            guard let region = positionCamera else {
                return
            }
            self?.map.setRegion(region, animated: true)
            
        }//замыкание
        $angleCamera
            .sink{[weak self ] heading in
                //print("Ancgle heading camera from notrh/0: ",heading)
                guard let self = self else {return}
                for annotation in archiveAnnotations {
                    
                    if annotation is AnnotationDriving {
                        guard let annotationView = map.view(for: annotation) as? DrivingAnnotationView else {return}
                        annotationView.updateTranfsform(heading: heading)
                    }
                    
                }
            }
            .store(in: &cancellabels)
        headingObserver = map.observe(\.camera.heading, options: [.new]) {[weak self] map, change in
            
            if let newHeading = change.newValue {
                print("KVO Новое направление: \(newHeading)")
                self?.angleCamera = newHeading
            }
        }
        displayLink = CADisplayLink(target: self, selector: #selector(trackHeading))
        displayLink?.add(to: .main, forMode: .common)
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
        else if annotation is AnnotationDriving {
            let identifer = "annotationDriving"
            
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = DrivingAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
            //print(abs(angleCamera - (annotation as! AnnotationDriving).tracker.angle))
            annotationView.annotation = annotation
            (annotationView as! DrivingAnnotationView).updateTranfsform(heading: angleCamera)
        }
        else if annotation is AnnotationParked {
            let identifer = "annotationParked"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = ParkedAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
        }
        else if annotation is AnnotationStopped {
            let identifer = "annotationStopped"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = StoppedAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
        }
        else if annotation is AnnotationBegin {
            let identifer = "annotationBegin"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = BeginAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
        }
        else if annotation is AnnotationEnd {
            let identifer = "annotationEnd"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = EndAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
        }
        else if annotation is AnnotationFall {
            let identifer = "annotationFall"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
            if annotationView == nil {
                annotationView = FallAnnotationView(annotation: annotation,reuseIdentifier:identifer)
            }
        }
        
        return annotationView
        
    }
    //    func mapView(_ mapView:MKMapView, regionDidChangeAnimated: Bool) {
    //        angleCamera = map.camera.heading
    //    }
    @objc func trackHeading() {
        if angleCamera != map.camera.heading {
            angleCamera = map.camera.heading
            //print("DCA Новое направление: \(angleCamera)")
            
        }
    }
    private func drawRoute(for archive:[TrackerViewModel]) {
        
        func distanceInMeters(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D) -> Double {
            let loc1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let loc2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
            let meters = loc1.distance(from: loc2)
            return Double(meters)
        }
        func strToDate(str:String) -> Date? {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
                    }
                }
            }
        }
        func setAngle(for arrTM: inout [TrackerMap]) {
            for i in 0..<arrTM.count {
                if arrTM[i].state == .driving {
                    for j in i+1..<arrTM.count {
                        if arrTM[j].state != .trash {
                            arrTM[i].angle = bearingDegrees(from: arrTM[i].coordinates, to: arrTM[j].coordinates)
                            break
                        }
                    }
                }
            }
        }
        
        
        func compressAndCheckValidityParkeds(arrTM: inout [TrackerMap],arrCC: inout [CLLocationCoordinate2D]) {
            for i in 0..<arrTM.count {
                var intervalBetweenParkeds = TimeInterval(0)
                if arrTM[i].state == .stoping {
                    
                    for j in i..<arrTM.count {
                        
                        if i == j {continue}
                        if arrTM[j].state == .driving || j == arrTM.count-1  {
                            print(intervalBetweenParkeds)
                            if intervalBetweenParkeds > 50 && intervalBetweenParkeds < 300 {
                                
                                arrTM[i].state = .stoping
                            }
                            else if intervalBetweenParkeds > 300 {
                                
                                arrTM[i].state = .parking
                            }
                            break
                        }
                        intervalBetweenParkeds += arrTM[j].time.timeIntervalSince(arrTM[j-1].time)
                        arrTM[j].state = .trash
                        
                    }
                }
            }
        }
        func checkValidityFall(arrTM: inout [TrackerMap]) {
            for i in 0..<arrTM.count-1 {
                if arrTM[i].state != .trash {
                    for j in (i+1)..<(arrTM.count) {
                        if arrTM[j].state != .trash && arrTM[j].time.timeIntervalSince(arrTM[i].time) > 120 {
                            arrTM[i].state = .fall
                        }
                    }
                }
            }
        }
        func setValidityBeginEnd(arrTM: inout [TrackerMap]) {
//            var flagBegin = false
//            var flagEnd = false
//            for i in 0..<arrTM.count/2 {
//                if arrTM[i].state != .trash && flagBegin != false {
//                    flagBegin = true
//                    arrTM[i].state = .begin
//                }
//                let endIndex = arrTM.count - i - 1
//                if arrTM[endIndex].state != .trash && flagEnd != false {
//                    flagEnd = true
//                    arrTM[endIndex].state = .end
//                }
//                if flagBegin && flagEnd {
//                    print(":)!@#!@3214124124")
//                    break
//                }
//            }
//            //arrTM.removeAll()
            var isEmptyBegin = true
            var isEmptyEnd = true
            for i in 0..<arrTM.count {
                if arrTM[i].state != .trash && isEmptyBegin  {
                    arrTM[i].state = .begin
                    isEmptyBegin = false
                }
            }
            for i in (0..<arrTM.count-1).reversed() {
                if arrTM[i].state != .trash && isEmptyEnd  {
                    arrTM[i].state = .end
                    isEmptyEnd = false
                }
            }
            
        }
        var coordinates:[CLLocationCoordinate2D] = []
        var statingTrackers:[TrackerMap] = []
        
        var last = CLLocationCoordinate2D(latitude: archive[0].lat, longitude: archive[0].long)
        
        
        
        for i in 0..<archive.count {//фильтрация данных
            let tracker = archive[i]
            if tracker.lat == 0 || tracker.long == 0  {
                print("coords: 0 tracker sos sos sos");
                if i+1 != archive.count {
                    last = CLLocationCoordinate2D(latitude: archive[i+1].lat, longitude: archive[i+1].long)
                }
                continue
            }
            if abs(Double(last.latitude + last.longitude) - (tracker.lat + tracker.long)) > 0.5{
                print("belicbelicbelicbelicbelic");
                print("last", last)
                print("now", tracker.lat, tracker.long)
                if i+1 != archive.count {
                    last = CLLocationCoordinate2D(latitude: archive[i+1].lat, longitude: archive[i+1].long)
                }
                continue
            }
            
            let current =  CLLocationCoordinate2D(latitude: tracker.lat, longitude: tracker.long)
            last = (statingTrackers.count != 0) ? statingTrackers[statingTrackers.count-1].coordinates : current
            let meters = distanceInMeters(from: last, to: current)
            //print("meters:", meters.rounded(), "speed: \(tracker.speed)km/h;", "time:",tracker.time, "lat:\(tracker.long); long:\(tracker.lat)")
            
            if meters >= 10 || tracker.speed > 0 {
                statingTrackers.append(TrackerMap(coordinates: current, meters: Int(meters), state: .driving,time: strToDate(str: tracker.time),speed:tracker.speed))
            }
            else {
                statingTrackers.append(TrackerMap(coordinates: current, meters: Int(meters), state: .stoping,time: strToDate(str: tracker.time),speed:tracker.speed))
            }
            
        }
        checkValidityDriving(arrTM: &statingTrackers, arrCC: &coordinates)
        compressAndCheckValidityParkeds(arrTM: &statingTrackers, arrCC: &coordinates)
        setAngle(for: &statingTrackers)
        checkValidityFall(arrTM: &statingTrackers)
        setValidityBeginEnd(arrTM: &statingTrackers)
        
        for statingTracker in statingTrackers {
            if statingTracker.state != .trash {
                coordinates.append(statingTracker.coordinates)
                //                print("meters:", statingTracker.meters, "speed: \(statingTracker.speed)km/h;", "time:",statingTracker.time, "lat:\(statingTracker.coordinates.longitude); long:\(statingTracker.coordinates.latitude)")
                
            }
            
            
            switch statingTracker.state {
            case .parking:
                print("паркинг esti") // проблема, нету ни одного паркинга
                
                archiveAnnotations.append(AnnotationParked(tracker:statingTracker))
            case .driving:
                
                archiveAnnotations.append(AnnotationDriving(tracker:statingTracker))
                
            case .stoping:
                archiveAnnotations.append(AnnotationStopped(tracker:statingTracker))
            case .trash:
                break
                
            case .begin:
                archiveAnnotations.append(AnnotationBegin(tracker: statingTracker))
            case .end:
                archiveAnnotations.append(AnnotationEnd(tracker: statingTracker))
            case .fall:
                archiveAnnotations.append(AnnotationFall(tracker: statingTracker))
            }
            
        }
        
        print("После фильтрации:")
        //        print("Мин. широта:", coordinates.map{$0.latitude}.min()!)
        //        print("Макс. широта:", coordinates.map{$0.latitude}.max()!)
        //        print("Мин. долгота:", coordinates.map{$0.longitude}.min()!)
        //        print("Макс. долгота:", coordinates.map{$0.longitude}.max()!)
        print("count coordinates:", coordinates.count)
        print("count statingsTrackersMap:",statingTrackers.count)
        print("count annotations:", archiveAnnotations.count)
        
        var routePolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        
        
        map.addOverlay(routePolyline)
        routesPolyline.append(routePolyline)
        map.setVisibleMapRect(routePolyline.boundingMapRect, edgePadding: .init(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        map.addAnnotations(archiveAnnotations)
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
    var speed:Int
    var angle:Double = 0
    var duration:TimeInterval = 0

    init(coordinates:CLLocationCoordinate2D,meters:Int,state:StateTracker,time:Date?,speed:Int) {
        self.coordinates = coordinates
        self.meters = meters
        self.state = state
        self.speed = speed
        guard let date = time else {/*print("AMP code 0");*/self.time = .distantPast;return}
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

class DrivingAnnotationView:MKAnnotationView {
    var icon = UIImageView(image: UIImage(named: "driving"))
    
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    private func setupUI() {
        icon.sizeToFit()
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 25),
            icon.heightAnchor.constraint(equalToConstant: 25),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
    }
    func updateTranfsform( heading:Double) {
        let selfAngle = (annotation as! AnnotationDriving).tracker.angle
        icon.transform = CGAffineTransform(rotationAngle: abs((selfAngle - heading)) * .pi / 180)
    }
    
}
class ParkedAnnotationView:MKAnnotationView {
    
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named: "parked")!, targetSize: CGSize(width: 35, height: 35))
        
    }
}
class StoppedAnnotationView:MKAnnotationView {
    
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named: "stopped")!, targetSize: CGSize(width: 35, height: 35))
        
    }
}
class FallAnnotationView:MKAnnotationView {
    
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named: "fall.png")!, targetSize: CGSize(width: 35, height: 35))
    }
}
class BeginAnnotationView:MKAnnotationView {
    
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named: "begin.png")!, targetSize: CGSize(width: 89, height: 89))
        
    }
}

class EndAnnotationView:MKAnnotationView {
    
    @MainActor required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(annotation:MKAnnotation,reuseIdentifier:String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        self.image = resizeImage(image: UIImage(named: "end.png")!, targetSize: CGSize(width: 100, height: 333))
        
    }
}

class AnnotationStopped:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!

    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker

    }
}
class AnnotationParked:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!

    
    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker
    }
}
class AnnotationFall:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!

    
    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker
    }
}
class AnnotationBegin:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!

    
    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker
    }
}
class AnnotationEnd:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!

    
    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker
    }
}

class AnnotationDriving:NSObject,MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    var tracker:TrackerMap!
    init(tracker:TrackerMap) {
        coordinate = tracker.coordinates
        self.tracker = tracker
    }
}

enum StateTracker {
    case begin, end, parking, driving, stoping, trash, fall
}

/// Вычисляет азимут (bearing) от `from` к `to` в градусах (0…360)
func bearingDegrees(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    // 1) Переводим широту/долготу в радианы
    let φ1 = from.latitude  * .pi / 180
    let λ1 = from.longitude * .pi / 180
    let φ2 = to.latitude    * .pi / 180
    let λ2 = to.longitude   * .pi / 180
    
    // 2) Разница долгот
    let Δλ = λ2 - λ1
    
    // 3) Компоненты X и Y
    let x = cos(φ2) * sin(Δλ)
    let y = cos(φ1) * sin(φ2)
    - sin(φ1) * cos(φ2) * cos(Δλ)
    
    // 4) Угол в радианах
    let θ = atan2(x, y)
    
    // 5) Переводим в градусы и нормализуем в [0;360)
    var degrees = θ * 180 / .pi
    if degrees < 0 {
        degrees += 360
    }
    return degrees
}
