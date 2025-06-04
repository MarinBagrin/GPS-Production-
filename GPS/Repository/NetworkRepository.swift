
import Foundation
import Combine
import Network
import MapKit
protocol NetworkRepository {
    func sendMessage(login:String, password:String)
    func restartConnection()
    func pushSignal()
    func sendRequestForArchive(initial:String,end:String,for pickedName: String)
    var stateAuthenticated: Observable<stateAuth> { get }
    var recivedTrackers:Observable<[Observable<TrackerModel>]> { get }
    var isConnected:Observable<Bool> { get }
    var recTrackersArchiveOn:AnyPublisher<[[TrackerModel]],Never>{get}

}
protocol NetworkRepositoryDataLayer {
    func notifyAboutChanheAddressConnection()
    var saveCorrectCredentials:((Credentials)->Void)? {get set}
    var getDataForConnect:(()->AddressModel)? {get set}
    var stateAuthenticated: Observable<stateAuth> { get }

    

}
class NetworkRepositoryImpl{
    static var user_ip:String!
    static var user_port:String!
    
    
    var recivedTrackers = Observable<[Observable<TrackerModel>]>([])
    var recTrackersArchive = CurrentValueSubject<[[TrackerModel]],Never>([])
    var recTrackersArchiveBuffer = [[TrackerModel]]()
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
    var currentLenMessage:Int = 0
    var collectionBytes = Data()
    
    lazy var connection:NWConnection? = nil
    
    init() {
        
        startAsyncManageConnection()
    }
    func restartConnection() {
        cancelConnection()
        configureConnection()
        print("attempt start server")
        connection?.start(queue: .global())
    }
    func cancelConnection()
    {
        connection?.cancel()
        connection = nil
    }
    private func configureConnection() {
        integ += 1
        var tlsOptions = NWProtocolTLS.Options()
        var tcpOptions = NWProtocolTCP.Options()
        // 2) Устанавливаем блок проверки сертификата сервера
        //    Здесь приводится самый простой вариант: любое доверие принимается.
        //    Для продакшена замените на реальную валидацию через SecTrustEvaluate.
        sec_protocol_options_set_verify_block( tlsOptions.securityProtocolOptions,
            { metadata, trust, complete in
                // Вариант «всегда доверять»:
                complete(true)
                
                // Если нужно проверять цепочку:
                // let secTrust = trust as! SecTrust
                // var result = SecTrustResultType.invalid
                // SecTrustEvaluate(secTrust, &result)
                // let isTrusted = (result == .unspecified || result == .proceed)
                // complete(isTrusted)
            },
            DispatchQueue.global()
        )
        guard let addresForConnect = getDataForConnect?() else {print("ошибка, get dataForConnect");return}
        host = NWEndpoint.Host(addresForConnect.host)
        port = NWEndpoint.Port(rawValue: addresForConnect.port)
        print(addresForConnect.host)
        print(addresForConnect.port)
        connection = NWConnection(host: host!, port: port!, using: NWParameters(tls: tlsOptions, tcp: tcpOptions))
        connection?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Соединение установлено и готово к работе.")
                self.isConnected.value = true
                self.recieveDataTrackers()
            case .waiting(let error):
                print("Соединение ожидает. Ошибка: \(error.localizedDescription)")
            case .failed(let error):
                print("Соединение не удалось. Ошибка: \(error.localizedDescription)")
                self.isConnected.value = false
            case .cancelled:
                print("Соединение было отменено.")
            case .preparing:
                print("Соединение готовится к установке.")
                print("kakoy raz",self.integ)
            default:
                break
            }
        }
    }
    private func startAsyncManageConnection() {
        Task {
            while true {
                try await Task.sleep(nanoseconds: 2_000_0000_00)
                if (self.isConnected.value == false) {
                    self.stateAuthenticated.value = .no
                    self.restartConnection()
                    print("perezapysk")
                }
            }
            print("xyinea vyslha")
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
    
    func recieveDataTrackers() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1_000_000) {  data, _, isComplete, error in
            if (error != nil) {
                print("off iz za error")
                self.isConnected.value = false
                return
            }
            if let data = data, !data.isEmpty {
                self.collectionBytes.append(data)
                if (self.currentLenMessage == 0 && self.collectionBytes.count >= 4) {
                    var len:Int32 = 0
                    _ = withUnsafeMutableBytes(of: &len) { ptr in
                        self.collectionBytes.copyBytes(to: ptr, count: 4)
                    }
                    self.currentLenMessage = Int(len.bigEndian)
                }
            


                
                if (self.currentLenMessage <= self.collectionBytes.count-4) {
                self.readMessageFromBuffer()
                    self.currentLenMessage = 0
        
                }
            }
            self.recieveDataTrackers()
            print("mnogo raz")
        }
    }
    func readMessageFromBuffer() {
        
        let start = collectionBytes.startIndex
        let from = collectionBytes.index(start, offsetBy: 4)
        let to = collectionBytes.index(from, offsetBy: currentLenMessage)
        
        let data = collectionBytes[from..<to]
        collectionBytes.removeFirst(4+currentLenMessage)
        guard let request = String(data: data.prefix(10), encoding: .utf8) else {print("no request recive"); return}
        if (request.contains("AllowAuth/")) {
            self.saveCorrectCredentials?(self.credentials!)
            self.stateAuthenticated.value = .yes
            if let startIndex = request.index(request.startIndex, offsetBy: 10, limitedBy: request.endIndex) {
                let organisationRecieve = String(request[startIndex...])
                if (organisationRecieve != self.organisationName) {
                    self.organisationName = organisationRecieve
                }
            }
        }
        else if(request.contains("NoAuth")) {
            self.stateAuthenticated.value = .wrong
        }
        else if (request.contains("Archive")) {
            do {
                let startReqIndex = request.index(request.startIndex, offsetBy: 7)
                let endReqIndex = request.index(startReqIndex, offsetBy: 2)
                
                let countArchives = Int(request[startReqIndex..<endReqIndex]) ?? -1
                print(request)
                print("need recieve countArchives", countArchives)
                let start = data.startIndex
                let from = data.index(start, offsetBy: 10)
                print("count archive bytes: ",data[from...])
                print("count collections bytes: ",collectionBytes.count)
                let recTrackers =  try tracker_list(serializedBytes:data[from...])
                print("Успешно десериализован archive:")
                self.recTrackersArchive.value.removeAll()
                var tempArchive = [TrackerModel]()
                for recTracker in recTrackers.trackers {
                    let configTracker = TrackerModel()
                    configTracker.name = recTracker.name
                    configTracker.battery = Int(recTracker.battery)
                    configTracker.lat = Double(recTracker.latitude) ?? 0
                    configTracker.long = Double(recTracker.longitude) ?? 0
                    configTracker.connectionNET = configTracker.lat == 0 ? .missing : .stable
                    configTracker.connectionGPS = configTracker.lat == 0 ? .missing : .stable
                    configTracker.time = recTracker.timeTrack
                    configTracker.speed = Int(recTracker.speed)
                    //configTracker.setAddress()
                    tempArchive.append(configTracker)
                }
                print("тут запонялется архвив trackers")
                self.recTrackersArchiveBuffer.append(tempArchive)
                if recTrackersArchiveBuffer.count == countArchives {
                    recTrackersArchive.value = recTrackersArchiveBuffer
                    recTrackersArchiveBuffer.removeAll()
                }
                
                print("count archiveTrackers: ", recTrackers.trackers.count)
                
            }
            catch {
                let startReqIndex = request.index(request.startIndex, offsetBy: 7)
                let endReqIndex = request.index(startReqIndex, offsetBy: 2)
                
                let countArchives = Int(request[startReqIndex..<endReqIndex]) ?? -1
                
                print("need recieve countArchives", countArchives)
                self.recTrackersArchiveBuffer.append([])
                if recTrackersArchiveBuffer.count == countArchives {
                    recTrackersArchive.value = recTrackersArchiveBuffer
                    recTrackersArchiveBuffer.removeAll()
                }
                
                
                print("Не успешно десериализован архив",error,"👄👄👄👄👄👄👄👄👄👄👄")
                
                
            }
        }
        else {
            do {
                // Десериализуем данные в объект tracker
                let recTrackers = try tracker_list(serializedBytes: data)
                print("Успешно десериализован объект: ")
                
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
                    configTracker.speed = Int(recTracker.speed)
                    configTracker.time = recTracker.timeTrack
                    print("RFSignal", Int(recTracker.coordinates), recTracker.coordinates)

                    configTracker.networkProcent = Int(recTracker.coordinates) ?? -1
                    print(configTracker.networkProcent)
                }
                self.recivedTrackers.value = self.recivedTrackers.value
            }
            catch {
                print("Ошибка при десериализации данных: \(error)")
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
    var recTrackersArchiveOn:AnyPublisher<[[TrackerModel]],Never> {
        return recTrackersArchive.eraseToAnyPublisher()
    }
    func sendRequestForArchive(initial:String,end:String, for pickedName:String) {
            
            let text = "ravch/\(pickedName)/\(initial)/\(end)/"
            let message = text.data(using: .utf8)!
        print("the data sended for archive: ",text)
            connection?.send(content: message, completion: .contentProcessed { error in
                if let error = error {
                    print("Request archive was not sended: \(error)")
                } else {
                    print("Request archive was sended")
                }
            })
        }
//    func sendRequestForArchive(initial:String,end:String, for pickedName:String) {//test
//        let coordinates: [CLLocationCoordinate2D] = [
//            // 1) Chișinău Railway Station
//            CLLocationCoordinate2D(latitude: 47.012500, longitude: 28.859722), // :contentReference[oaicite:0]{index=0}
//
//            // 2) Выход на Aleea Gării / Str. Gării
//            CLLocationCoordinate2D(latitude: 47.013100, longitude: 28.857560),
//
//            // 3) Пересечение с Bulevardul Ștefan cel Mare
//            CLLocationCoordinate2D(latitude: 47.013660, longitude: 28.855130),
//
//            // 4) Проезд мимо Parcul „Valea Morilor”
//            CLLocationCoordinate2D(latitude: 47.014260, longitude: 28.852200),
//
//            // 5) Усадьба у пересечения с Strada Muncești
//            CLLocationCoordinate2D(latitude: 47.015000, longitude: 28.849000),
//
//            // 6) Вдоль Bulevardul Ștefan cel Mare
//            CLLocationCoordinate2D(latitude: 47.016000, longitude: 28.846000),
//
//            // 7) Пересечение с Strada Mitropolit Varlaam
//            CLLocationCoordinate2D(latitude: 47.017200, longitude: 28.843500),
//
//            // 8) Мимо Grădina Publică „Ștefan cel Mare”
//            CLLocationCoordinate2D(latitude: 47.018800, longitude: 28.841500),
//
//            // 9) Около Hotel National
//            CLLocationCoordinate2D(latitude: 47.020500, longitude: 28.839700),
//
//            // 10) Около Teatrul Național „Mihai Eminescu”
//            CLLocationCoordinate2D(latitude: 47.021500, longitude: 28.836800),
//
//            // 11) Arcul de Triumf
//            CLLocationCoordinate2D(latitude: 47.024590, longitude: 28.832372)  // :contentReference[oaicite:1]{index=1}
//        ]
//
//        var trackersArch = [TrackerModel]()
//        for i in coordinates {
//            trackersArch.append(TrackerModel())
//            trackersArch.last?.lat = i.latitude
//            trackersArch.last?.long = i.longitude
//        }
//        recTrackersArchive.value = trackersArch
//    }
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
    func pushSignal() {
        recivedTrackers.value = recivedTrackers.value
        recTrackersArchive.value.removeAll()
    }

}
    




//func restartConnectionWithServer() {
//    g_server.connection.cancel()
//    g_server = Socket()
//    g_server.startConnection()
//}
