import MapKit
protocol MapViewModelDelegate {
    var trackers:Observable<[Observable<TrackerViewModel>]>{get set}
    var positionCamera:Observable<MKCoordinateRegion?>{get set}
    var textSearchTrackers:Observable<String>{get set}
    var redrawTrackersTable:Observable<Bool>{get set}
    func sortTrackerByName(_ forName:String)
}


class MapViewModel {
    var authUseCase:AuthUseCase    
    var trackersUseCase:TrackersUseCase
    var connectionServerUseCase:ConnectionServerUseCase
    var trackers = Observable<[Observable<TrackerViewModel>]>([])
    var positionCamera = Observable<MKCoordinateRegion?>(nil)
    var textSearchTrackers = Observable<String>("")
    var isConnected = Observable<Bool>(false)
    var isAuthenticated = Observable<stateAuth>(.no)
    var redrawTrackersTable = Observable<Bool>(false)
    var onOpenSettings:(() -> Void)?

    
    
    init(repositories:Repositories) {
        authUseCase = AuthUseCase(networkRepository: repositories.network )
        trackersUseCase = TrackersUseCase(networkRepository: repositories.network)
        connectionServerUseCase = ConnectionServerUseCase(networkRepository: repositories.network)
        bind()
    }
    func checkAuthentification(login:String, password:String)
    {
        authUseCase.sendRequest(login: login, password: password)
    }
    func settingsButtonTapped() {
        onOpenSettings?()
    }
    private func bind() {
        authUseCase.getObservableStateAuthenticated().bind{[weak self] state in self?.isAuthenticated.value = state}
        
        connectionServerUseCase.getObservableIsConnected().bind{[weak self] isConnected in
            self?.isConnected.value = isConnected
            
            if (!isConnected) {
                print("view model IsConnected: ", false)
                self?.connectionServerUseCase.restartConnectionServer()
                self?.isAuthenticated.value = .no
            }
            else{
                print("view model IsConnected: ", true)
            }
        }
        
        trackersUseCase.getObservableTrackers().bind{[weak self] trackers in
            self?.trackers.value = trackers.map{ trackerModel in
                let observableTrackerVM = Observable<TrackerViewModel>(TrackerViewModel(trackerModel.value))
                trackerModel.bind{[weak observableTrackerVM] tracker in
                    observableTrackerVM?.value = TrackerViewModel(tracker)
                }
                return observableTrackerVM
            }
        }
        
    }
    
}







class Observable<T> {
    var value:T {
        didSet {
            DispatchQueue.main.async {
                self.subsribers.forEach{subscriber in subscriber(self.value)}
            }
        }
    }
    private var subsribers:[(T)->Void] = []
    init(_ value:T) {
        self.value = value
        
    }
    func bind(subsriber: @escaping(T)->Void) {
        subsribers.append(subsriber)
        subsriber(value)
    }
    func resetObservable(resetValue:T) {
        value = resetValue
    }
}

class TrackerViewModel {
    var lat: Double
    var long: Double
    var name: String
    var id: Int
    var battery: Int
    var time: String
    var address: String
    var connectionGPS:Conection
    var connectionNET:Conection
    var neededHiden:Bool = false
    init(_ trackerModel:TrackerModel) {
        lat = trackerModel.lat
        long = trackerModel.long
        name = trackerModel.name
        id = trackerModel.id
        battery = trackerModel.battery
        time = trackerModel.time
        address = trackerModel.address ?? ""
        connectionGPS = trackerModel.connectionGPS
        connectionNET = trackerModel.connectionNET
    }
    
    func updateTracker(trackerModel:TrackerModel)->TrackerViewModel{
        self.lat = trackerModel.lat
        self.long = trackerModel.long
        //many
        return self
    }
    
}

extension MapViewModel:MapViewModelDelegate {
    func sortTrackerByName(_ forName: String) {
        func sortTrackers(_ forName:String) {
            if (forName.isEmpty) {
                turnOffisHidenListTrackers()
                return
            }
            var filter:[Float] = Array(repeating: 0, count: trackers.value.count)
            var i = 0
            for tracker in trackers.value {
                
                for charIn in forName {
                    var score:Float = 2.0
                    
                    for charName in tracker.value.name {
                        if (charIn == charName) {
                            filter[i] += score
                            break
                        }
                        score -= 0.1
                    }
                }
                i += 1
            }
            trackers.value.removeAll()
            
            while(true) {
                
                var max:Float = 0
                var index = -1
                for i in 0..<filter.count {
                    if (filter[i] > max) {
                        max = filter[i]
                        index = i
                    }
                }
                if (index == -1 || max == 0) {break}
                trackers.value[index].value.neededHiden = true
                filter[index] = -1
            }
        }
    }
    
    private func turnOffisHidenListTrackers(){
        trackers.value.forEach{$0.value.neededHiden = false}
    }
}
enum stateAuth {
    case yes,no,wrong,processing
}
