import Combine
import Foundation
class SettingsViewModel {
    var settingsUseCase:SettingsUseCase?
    @Published var ip = String("")
    @Published var port = String("")
    @Published var selectedLanguage:Language = .eng
    @Published var isSavedAuth = false
    var onRestartFlow:(()->Void)?
    private var cancellabels = Set<AnyCancellable>()
    init(settingsRepository:SettingsRepository) {
        self.settingsUseCase = SettingsUseCase(settingsRepository: settingsRepository)
        bindViewModel()
    }
    private func bindViewModel() {
        settingsUseCase?.getPublisherIp()
            .sink { [weak self] ip in
                self?.ip = ip
            }
            .store(in: &cancellabels)
        settingsUseCase?.getPublisherPort()
            .sink { [weak self] port in
                self?.port = port
            }
            .store(in: &cancellabels)
        settingsUseCase?.getPublisherSelectedLanguage()
            .sink { [weak self] language in
                self?.selectedLanguage = language
            }
            .store(in: &cancellabels)
        settingsUseCase?.getPublisherIsSavedAuth()
            .sink { [weak self] isSaved in
                self?.isSavedAuth = isSaved
            }
            .store(in: &cancellabels)
    }
    func setSelectedLanguage(language:Language) {
        settingsUseCase?.setSelectedLanguage(language: language)
    }
    func toogleSaveCredentials() {
        settingsUseCase?.updateToogleSaveCredentials()
    }
    func updateIpIfValid(range:NSRange, with:String) {
        settingsUseCase?.updateIpIfValid(range: range, with: with)
    }
    func updatePortIfValid(range:NSRange, with:String) {
        settingsUseCase?.updatePortIfValid(range: range, with: with)
    }
    func saveConfigurationSettings() {
        let flag = settingsUseCase?.isNeededRestartMainScreen()
        settingsUseCase?.saveConfigurationSettings()
        if flag ?? false {
            onRestartFlow?()
        }
    }
    func restoreSavedSettings() {
        settingsUseCase?.restoreSavedSettings()
    }
}

