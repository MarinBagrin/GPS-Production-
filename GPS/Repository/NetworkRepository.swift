
import Foundation
import Network
protocol NetworkRepository {
    func sendMessage(login:String, password:String)
    func restartConnection()
    var stateAuthenticated: Observable<stateAuth> { get }
    var recivedTrackers:Observable<[Observable<TrackerModel>]> { get }
    var isConnected:Observable<Bool> { get }

}
protocol NetworkRepositoryDataLayer {
    func notifyAboutChanheAddressConnection()
    var saveCorrectCredentials:((Credentials)->Void)? {get set}
    var getDataForConnect:(()->AddressModel)? {get set}
    

}
class NetworkRepositoryImpl{
    static var user_ip:String!
    static var user_port:String!
    
    
    var recivedTrackers = Observable<[Observable<TrackerModel>]>([])
    
    var isConnected = Observable<Bool>(false)
    var stateAuthenticated = Observable<stateAuth>(.no)
    var organisationName = ""
    private var isStarted = false
    var getDataForConnect:(()->AddressModel)?
    var saveCorrectCredentials:((Credentials)->Void)?
    var host:NWEndpoint.Host? = nil
    var port:NWEndpoint.Port? = nil
    var credentials:Credentials?
    var integ = 0

    lazy var connection:NWConnection? = nil
    
    init() {
        
        print(NWEndpoint.Host(UserDefaults.standard.string(forKey: "ip") ?? "localhost"))
        print(UInt16(UserDefaults.standard.integer(forKey: "port")))
        
    }
    func restartConnection() {
        cancelConnectionIfNeeded()
        configureConnection()
        startAsyncManageConnection()
    }
    
    private func configureConnection() {
        integ += 1
        guard let addresForConnect = getDataForConnect?() else {print("ошибка, get dataForConnect");return}
        host = NWEndpoint.Host(addresForConnect.host)
        port = NWEndpoint.Port(rawValue: addresForConnect.port)
        print(addresForConnect.host)
        print(addresForConnect.port)
        connection = NWConnection(host: host!, port: port!, using: .tcp)
        connection?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Соединение установлено и готово к работе.")
                self.isConnected.value = true
                self.recieveDataTrackers()
            case .waiting(let error):
                print("Соединение ожидает. Ошибка: \(error.localizedDescription)")
                //self.isConnected.value = false
            case .failed(let error):
                print("Соединение не удалось. Ошибка: \(error.localizedDescription)")
                self.isConnected.value = false
            case .cancelled:
                print("Соединение было отменено.")
                self.isConnected.value = false
            case .preparing:
                print("Соединение готовится к установке.")
                print("kakoy raz",self.integ)
            default:
                break
            }
        }
    }
    private func startAsyncManageConnection() {
        print("attempt start server")
        connection?.start(queue: .global())
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2.5)
            if (self.isConnected.value == false) {
                self.stateAuthenticated.value = .no
                self.isConnected.value = false
                print("perezapysk")
            }
        }
    }
    
    func cancelConnectionIfNeeded()
    {
        if (isStarted) {
            connection?.cancel()
            connection = nil
        }
    }
    
    
    func sendRequestUnAuth() {
        let text = "setInUnAuth"
        let message = text.data(using: .utf8)!
        connection?.send(content: message, completion: .contentProcessed { error in
            if let error = error {// ispraviti
                print("Request toUnAuth was not sended: \(error)")
            } else {
                print("Request toUnAuth was sended")
                self.stateAuthenticated.value = .no
            }
        })
    }
    func sendRequestForArchive() {
        
    }
    func recieveDataTrackers() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 64000) {  data, _, isComplete, error in
            if (error != nil) {
                print("off iz za error")
                self.isConnected.value = false
                return
            }
            if let data = data, !data.isEmpty {
                let recieveAllow = String(decoding: data, as: UTF8.self)
                if (recieveAllow.contains("AllowAuth/")) {
                    self.saveCorrectCredentials?(self.credentials!)
                    self.stateAuthenticated.value = .yes
                    if let startIndex = recieveAllow.index(recieveAllow.startIndex, offsetBy: 10, limitedBy: recieveAllow.endIndex) {
                        let organisationRecieve = String(recieveAllow[startIndex...])
                        if (organisationRecieve != self.organisationName) {
                            self.organisationName = organisationRecieve
                        }
                    }
                }
                else if(recieveAllow.contains("UnAllowAuth")) {
                    self.stateAuthenticated.value = .wrong
                }
                else {
                    do {
                        // Десериализуем данные в объект tracker
                        let recTrackers = try tracker_list(serializedBytes: data)
                        print("Успешно десериализован объект: \(recTrackers)")
                        
                        for i in 0..<recTrackers.trackers.count {
                            let recTracker = recTrackers.trackers[i]
                            if self.recivedTrackers.value.count == i {
                                self.recivedTrackers.value.append(Observable<TrackerModel>(TrackerModel()))
                            }
                            let configTracker = self.recivedTrackers.value[i].value
                            configTracker.name = recTracker.name
                            configTracker.battery = Int(recTracker.battery)
                            configTracker.lat = Double(recTracker.latitude) ?? 0
                            configTracker.long = Double(recTracker.longitude) ?? 0
                            configTracker.connectionNET = configTracker.lat == 0 ? .missing : .stable
                            configTracker.connectionGPS = configTracker.lat == 0 ? .missing : .stable
                            configTracker.setAddress()
                        }
                        self.recivedTrackers.value = self.recivedTrackers.value
                    }
                    catch {
                        print("Ошибка при десериализации данных: \(error)")
                    }
                }
                self.recieveDataTrackers()
            }
        }
    }
}
extension NetworkRepositoryImpl:NetworkRepositoryDataLayer {

    func notifyAboutChanheAddressConnection() {
        print("Smena Ip Notify RepNet")
        isConnected.value = false
    }
}
extension NetworkRepositoryImpl:NetworkRepository {
    func sendMessage(login:String, password:String) {
        let message = (login + "/" + password + "/").data(using: .utf8)!
        connection?.send(content: message, completion: .contentProcessed { error in
            if let error = error {// ispraviti
                print("Auth attempt is not sended: \(error)")
                self.stateAuthenticated.value = .wrong
            } else {
                print("Auth attempt was sended")
                self.stateAuthenticated.value = .processing
            }
        })
        credentials = Credentials(login: login, password: password)
    }
}
    




//func restartConnectionWithServer() {
//    g_server.connection.cancel()
//    g_server = Socket()
//    g_server.startConnection()
//}
