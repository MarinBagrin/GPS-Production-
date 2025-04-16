
class TrackersUseCase {
    private let networkRepository:NetworkRepository
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    
    func getObservableTrackers() -> Observable<[Observable<TrackerModel>]> {
        return networkRepository.recivedTrackers
    }
}
