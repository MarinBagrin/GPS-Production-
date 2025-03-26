//
//  Socket.swift
//  GPS
//
//  Created by Marin on 15.01.2025.
//
import Foundation
import Network
var timewait = 0
class Socket {
    let host = NWEndpoint.Host("192.168.0.44")
    let port = NWEndpoint.Port(49500)
    var isConnected: Bool = false
    lazy var connection = NWConnection(host: host, port: port, using: .tcp)
    var isLeasinig: Bool = false
    //
    init() {
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Соединение установлено и готово к работе.")
                self.isConnected = true
            case .waiting(let error):
                print("Соединение ожидает. Ошибка: \(error.localizedDescription)")
                self.isConnected = false
            case .failed(let error):
                print("Соединение не удалось. Ошибка: \(error.localizedDescription)")
                self.isConnected = false

            case .cancelled:
                print("Соединение было отменено.")
                self.isConnected = false
            case .preparing:
                print("Соединение готовится к установке.")
                DispatchQueue.main.async{
                    if (mainView.authentication.menuAuth.tryConnectServer.superview == nil) {
                        mainView.authentication.menuAuth.setActiveTryingConnect()
                    }
                }
            default:
                break
            }
        }
    }
    
    func sendRequest() {
        let message = "get".data(using: .utf8)!
        connection.send(content: message, completion: .contentProcessed { error in
            if let error = error {// ispraviti
                print("Request was not sended: \(error)")
            } else {
                print("Request was sended")
            }
        })
    }
    
    func sendMessage(text: String) {
        let message = text.data(using: .utf8)!
        connection.send(content: message, completion: .contentProcessed { error in
            if let error = error {// ispraviti
                print("Message was not sended: \(error)")
            } else {
                print("Message was sended")
            }
        })
    }
    func sendRequestUnAuth() {
        let text = "setInUnAuth"
        let message = text.data(using: .utf8)!
        connection.send(content: message, completion: .contentProcessed { error in
            if let error = error {// ispraviti
                print("Request toUnAuth was not sended: \(error)")
            } else {
                print("Request toUnAuth was sended")
            }
        })
    }
    
    func receiveData() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                print("Получены данные: \(String(decoding: data, as: UTF8.self))")
                
            }
            if isComplete {
                print("Передача завершена.")
            }
        }
    }
    func recieveDataTrackers() {
        isLeasinig = true
        connection.receive(minimumIncompleteLength: 1, maximumLength: 64000) {  data, _, isComplete, error in
            self.isLeasinig = false
            if let data = data {
                let recieveAllow = String(decoding: data, as: UTF8.self)
                if (recieveAllow.contains("AllowAuth")) {
                    DispatchQueue.main.async {
                        mainView.authentication.removeFromSuperview()
                        if let startIndex = recieveAllow.index(recieveAllow.startIndex, offsetBy: 10, limitedBy: recieveAllow.endIndex) {
                            let organisation = String(recieveAllow[startIndex...])
                            if (organisation != mainView.authentication.organisation) {
                                mainView.authentication.organisation = organisation
                                STServer.clearBothListTrackers()
                                mainView.listMaps.activeView.maps[0].clearListAnnotations()
                            }
                        }
                    }
                    mainView.authentication.menuAuth.state = "AllowAuth"

                }
                else if(recieveAllow == "UnAllowAuth") {
                    mainView.authentication.menuAuth.state = recieveAllow
                    
                }
                do {
                    // Десериализуем данные в объект tracker
                    let recTrackers = try tracker_list(serializedBytes: data)
                    print("Успешно десериализован объект: \(recTrackers)")
                    for i in 0..<recTrackers.trackers.count {
                        let recTracker = recTrackers.trackers[i]
                        if STServer.trackers.count == i {
                            STServer.trackers.append(Tracker())
                        }
                        let configTracker = STServer.trackers[i]
                        configTracker.name = recTracker.name
                        configTracker.battery = Int(recTracker.battery)
                        configTracker.lat = Double(recTracker.latitude) ?? 0
                        configTracker.long = Double(recTracker.longitude) ?? 0
                        configTracker.setAddress()
                    }
                    DispatchQueue.main.async {
                        mainView.listMaps.activeView.checkAndAppendTrackers()
                    }
                }
                catch {
                    print("Ошибка при десериализации данных: \(error)")
                }
            }
        }
    }

    func startConnection() {
        connection.start(queue: .global())
    }
    
    func restartConnection() {
        connection.restart()
        print("restartConnection")
    }
}
    
    




