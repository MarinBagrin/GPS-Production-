import Combine
class AuthUseCase {
    private let networkRepository:NetworkRepository
    private let settingsRepository:SettingsRepositoryAuth
    
    init(repositories:Repositories) {
        self.networkRepository = repositories.network
        self.settingsRepository = repositories.settings
    }
    func saveCredentialsInMemmory() {
        settingsRepository.saveCredentialsInMemmory()
    }
    func sendRequest(login:String, password:String) {
        networkRepository.sendMessage(login: login, password: password)
    }
    func getCredentialsAuth() -> Credentials {
        return settingsRepository.getCredentials
    }
    func getObservableStateAuthenticated() -> Observable<stateAuth> {
        return networkRepository.stateAuthenticated
    }
    func getPublisherIsSaved() -> AnyPublisher<Bool,Never> {
        return settingsRepository.isSavedAuthOn
    }
    func getShowingRouteFlag() -> AnyPublisher<Bool,Never> {
        return settingsRepository.isShowingRouteOn
    }
    func toogleShowingRouteFlag() {
        settingsRepository.toogleShowingRouteFlag()
    }
}
