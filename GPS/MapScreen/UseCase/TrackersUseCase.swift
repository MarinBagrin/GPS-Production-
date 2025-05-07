import Combine
class TrackersUseCase {
    private let networkRepository:NetworkRepository
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    
    func sendSignal() {
        networkRepository.pushSignal()
    }
    func getPublisherArchive() -> AnyPublisher<[TrackerModel],Never> {
        return networkRepository.recTrackersArchiveOn
    }
    func getObservableTrackers() -> Observable<[Observable<TrackerModel>]> {
        return networkRepository.recivedTrackers
    }
    func downloadArchiveTrackers(initial:String,end:String, for pickedName:String) {
        networkRepository.sendRequestForArchive(initial:initial,end:end, for:pickedName)
    }
}


