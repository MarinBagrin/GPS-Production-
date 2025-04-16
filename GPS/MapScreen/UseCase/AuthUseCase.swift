
class AuthUseCase {
    private let networkRepository:NetworkRepository
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    
    func sendRequest(login:String, password:String) {
        networkRepository.sendMessage(login: login, password: password)
    }
    func getObservableStateAuthenticated() -> Observable<stateAuth> {
        return networkRepository.stateAuthenticated

    }
    
}
