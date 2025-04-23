import Combine
import Foundation
protocol SettingsRepository {
    var ipOn:AnyPublisher<String,Never> {get}
    var portOn:AnyPublisher<String,Never> {get}
    var selectedLanguageOn:AnyPublisher<Language,Never> {get}
    var isSavedAuthOn:AnyPublisher<Bool,Never> {get}
    func replaceIp(forRange:NSRange,with:String)
    func replacePort(forRange:NSRange,with:String)
    func toogleSaveCredentialsFlag()
    func setSelectedLanguage(language:Language)
    func saveConfigurationSettings()
    func restoreSavedSettings() 
    func isChangedSettings() ->Bool

}
protocol SettingsRepositoryAuth {
    var getCredentials:Credentials {get}
    var isSavedAuthOn:AnyPublisher<Bool,Never> {get}
    func saveCredentialsInMemmory()

}

class SettingsRepositoryImpl: SettingsRepository {
    private var ip = CurrentValueSubject<String,Never>(UserDefaults.standard.string(forKey: "ip") ?? "192.168.0.44")
    private var port = CurrentValueSubject<String,Never>(UserDefaults.standard.string(forKey: "port") ?? "49500")
    private var selectedLanguage = CurrentValueSubject<Language,Never>(
        buttonsLongLanguageDict[UserDefaults.standard.string(forKey: "language") ?? "🇺🇸 English"]!)
    private var isSavedAuth = CurrentValueSubject<Bool,Never>(UserDefaults.standard.bool(forKey: "isSaved"))
    private var networkRepository:NetworkRepositoryDataLayer
    private var credentials = Credentials(login: UserDefaults.standard.string(forKey: "login") ?? "",
                                          password: UserDefaults.standard.string(forKey: "pass") ?? "")
    var ipOn:AnyPublisher<String,Never> { ip.eraseToAnyPublisher()}
    var portOn:AnyPublisher<String,Never> {port.eraseToAnyPublisher()}
    var selectedLanguageOn:AnyPublisher<Language,Never> {selectedLanguage.eraseToAnyPublisher()}
    var isSavedAuthOn:AnyPublisher<Bool,Never> {isSavedAuth.eraseToAnyPublisher()}
    
    init(networkRepository:NetworkRepositoryDataLayer) {
        self.networkRepository = networkRepository
        self.networkRepository.getDataForConnect = {[weak self] in
            return AddressModel(host: self?.ip.value ?? "", port: UInt16(self?.port.value ?? "0") ?? 0)
        }
        self.networkRepository.saveCorrectCredentials = {[weak self] value in
            self?.credentials = value
        }
        lang = selectedLanguage.value
    }
    
    
    func isChangedSettings() ->Bool {
        let isChangedIpPort = UserDefaults.standard.string(forKey: "ip") ?? "nill" != ip.value || UserDefaults.standard.string(forKey: "port") ?? "49500" != port.value
        var isChangedLanguage = false
        if let storageLanguage = buttonsLongLanguageDict[UserDefaults.standard.string(forKey: "language") ?? ""] {
            isChangedLanguage = storageLanguage != selectedLanguage.value
        }
        return isChangedIpPort || isChangedLanguage
    }
    func saveConfigurationSettings() {
        UserDefaults.standard.set(buttonsShortLanguageDict[selectedLanguage.value], forKey: "language")
        UserDefaults.standard.set(isSavedAuth.value, forKey: "isSaved")
        UserDefaults.standard.set(ip.value, forKey: "ip")
        UserDefaults.standard.set(port.value, forKey: "port")
    }
    func restoreSavedSettings() {
        ip = CurrentValueSubject<String,Never>(UserDefaults.standard.string(forKey: "ip") ?? "95.65.72.7")
        port = CurrentValueSubject<String,Never>(UserDefaults.standard.string(forKey: "port") ?? "49500")
        selectedLanguage = CurrentValueSubject<Language,Never>(
        buttonsLongLanguageDict[UserDefaults.standard.string(forKey: "language") ?? "🇺🇸 English"]!)
        isSavedAuth = CurrentValueSubject<Bool,Never>(UserDefaults.standard.bool(forKey: "isSaved"))
    }
    

    func setSelectedLanguage(language:Language) {
        selectedLanguage.value = language
    }

    func toogleSaveCredentialsFlag() {
        isSavedAuth.value.toggle()

    }
    
    func replaceIp(forRange:NSRange,with:String) {
        guard let stringRange = Range(forRange,in: ip.value) else {
            return
        }
        ip.value = ip.value.replacingCharacters(in: stringRange, with: with)

    }
    func replacePort(forRange:NSRange,with:String) {
        guard let stringRange = Range(forRange,in: port.value) else {
            return
        }
        port.value = port.value.replacingCharacters(in: stringRange, with: with)

    }
}
extension SettingsRepositoryImpl:SettingsRepositoryAuth {
    var getCredentials:Credentials {return credentials}
    func saveCredentialsInMemmory() {
        UserDefaults.standard.set(credentials.login, forKey: "login")
        UserDefaults.standard.set(credentials.password, forKey: "pass")
    }
}

