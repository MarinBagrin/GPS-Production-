class ConnectionServerUseCase {
    private var networkRepository:NetworkRepository
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    func getObservableIsConnected() -> Observable<Bool> {
        return networkRepository.isConnected
    }
    func restartConnectionServer() {
        networkRepository.restartConnection()
     }
}
