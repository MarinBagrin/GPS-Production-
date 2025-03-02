//
//  Socket.swift
//  GPS
//
//  Created by Marin on 15.01.2025.
//
import Foundation
import Network

class Socket {
    let host = NWEndpoint.Host("178.168.69.240")
    let port = NWEndpoint.Port(49500)
    var isConnected: Bool = false
    lazy var connection = NWConnection(host: host, port: port, using: .tcp)
    //
    init() {
        connection.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    print("Соединение установлено и готово к работе.")
                self.sendMessage(text: "ea tvoy rot ebal")
                    self.isConnected = true
                case .waiting(let error):
                    print("Соединение ожидает. Ошибка: \(error.localizedDescription)")
                case .failed(let error):
                    print("Соединение не удалось. Ошибка: \(error.localizedDescription)")
                    self.isConnected = false
                self.connection.cancel()
                case .cancelled:
                self.isConnected = false
                        print("Соединение было отменено.")
                DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                    self.startConnection()
                }
                case .preparing:
                    print("Соединение готовится к установке.")
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
                print("Request was not sended: \(error)")
            } else {
                print("Request was sended")
            }
        })
    }
    
    func startConnection() {
        connection.start(queue: .global())
    }
    
    func restartConnection() {
        connection.restart()
    }
}






