import Foundation
import Combine
class SettingsUseCase {
    private let settingsRepository:SettingsRepository
    init(settingsRepository:SettingsRepository) {
       
    self.settingsRepository = settingsRepository
    }
    func restoreSavedSettings() {
        settingsRepository.restoreSavedSettings()
    }
    func isNeededRestartMainScreen() -> Bool {
        return settingsRepository.isChanchedIpOrPort()
    }
    func saveConfigurationSettings() {
        settingsRepository.saveConfigurationSettings()
    }
    func setSelectedLanguage(language:Language) {
        settingsRepository.setSelectedLanguage(language: language)
    }
    func updateToogleSaveCredentials() {
        settingsRepository.toogleSaveCredentialsFlag()
    }
    func updateIpIfValid(range:NSRange,with:String) {
        if IpValidator().validate(with) {
            settingsRepository.replaceIp(forRange: range, with: with)
        }
    }
    func updatePortIfValid(range:NSRange,with:String) {
        if IpValidator().validate(with) {
            settingsRepository.replacePort(forRange: range, with: with)
        }
    }
    func getPublisherIp() -> AnyPublisher<String,Never>{
        return settingsRepository.ipOn
    }
    func getPublisherPort() -> AnyPublisher<String,Never>{
        return settingsRepository.portOn
    }
    func getPublisherSelectedLanguage() -> AnyPublisher<Language,Never>{
        return settingsRepository.selectedLanguageOn
    }
    func getPublisherIsSavedAuth() -> AnyPublisher<Bool,Never>{
        return settingsRepository.isSavedAuthOn
    }
}


