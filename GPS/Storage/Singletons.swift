//
//  Singletons.swift
//  GPS
//
//  Created by Marin on 04.01.2025.
//

class STServer {
    //    static var login: String!
    //    static var password: String!
    static var trackers:[Tracker] = []
    static var filteredTrackers:[Tracker] = trackers
    
    static func filterByTextField(inString:String) {
        if (inString.isEmpty) {
            filteredTrackers = trackers
            return
        }
        var filter:[Float] = Array(repeating: 0, count: STServer.trackers.count)
        var i = 0
        for tracker in STServer.trackers {
            
            for charIn in inString {
                var score:Float = 2.0
                
                for charName in tracker.name {
                    if (charIn == charName) {
                        filter[i] += score
                        break
                    }
                    score -= 0.1
                }
            }
            i += 1
        }
        for ind in 0..<STServer.trackers.count {
            print(filter[ind], "-", STServer.trackers[ind].name!)
        }
        print("-------------------------------------------0")
        STServer.filteredTrackers.removeAll()
        
        while(true) {
            
            var max:Float = 0
            var index = -1
            for i in 0..<filter.count {
                if (filter[i] > max) {
                    print(filter[i],">",max)
                    max = filter[i]
                    
                    index = i
                    print(index,filter[i])

                }
            }
            if (index == -1 || max == 0) {break}
            STServer.filteredTrackers.append(STServer.trackers[index])
            filter[index] = -1
        }
        print("-------------------------------------------1")
        for i in STServer.filteredTrackers {
            print(i.name!, terminator: " ")
        }

    }
    static func clearBothListTrackers() {
        STServer.filteredTrackers = []
        STServer.trackers = []
    }
    
}

let translate: [String: [String: String]] = [
    "eng": [
        "login": "Log In",
        "plsauth": "Please authenticate.",
        "authing0": "Authenticating, please wait",
        "authing1": "Authenticating, please wait.",
        "authing2": "Authenticating, please wait..",
        "authing3": "Authenticating, please wait...",
        "servconat0": "Server connection attempt",
        "servconat1": "Server connection attempt.",
        "servconat2": "Server connection attempt..",
        "servconat3": "Server connection attempt...",
        "incpaslog": "Incorrect password or login!",
        "settings": "SETTINGS",
        "enterip": "Enter IP",
        "enterport": "Enter Port",
        "sellang": "Select language",
        "savelogpas": "Save login or password",
        "cancel": "Cancel",//11
        "close": "Close",
        "alert": "Alert!",
        "sure?": "Are you sure you want to save the changes?",
        "yes": "Yes",
        "no": "No",
        "sgtracker": "Search GPS Tracker",
        "sortby": "Sort by",
        "name": "Name",
        "battery": "Battery",
        "gps": "GPS",
        "online": "Online"
    ],
    "ru": [
        "login": "Войти",
        "plsauth": "Пожалуйста, авторизуйтесь.",
        "authing0": "Авторизация, подождите",
        "authing1": "Авторизация, подождите.",
        "authing2": "Авторизация, подождите..",
        "authing3": "Авторизация, подождите...",
        "servconat0": "Попытка подключения к серверу",
        "servconat1": "Попытка подключения к серверу.",
        "servconat2": "Попытка подключения к серверу..",
        "servconat3": "Попытка подключения к серверу...",
        "incpaslog": "Неверный логин или пароль!",
        "settings": "НАСТРОЙКИ",
        "enterip": "Введите IP",
        "enterport": "Введите порт",
        "sellang": "Выберите язык",
        "savelogpas": "Сохранить логин или пароль",
        "cancel": "Отмена",//11
        "close": "Закрыть",
        "alert": "Внимание!",
        "sure?": "Вы уверены, что хотите сохранить изменения?",
        "yes": "Да",
        "no": "Нет",
        "sgtracker": "Поиск GPS-трекера",
        "sortby": "Сортировать по",
        "name": "Имя",
        "battery": "Батарея",
        "gps": "GPS",
        "online": "Онлайн"
    ],
    "ro": [
        "login": "Autentificare",
        "plsauth0": "Vă rugăm să vă autentificați",
        "plsauth1": "Vă rugăm să vă autentificați.",
        "plsauth2": "Vă rugăm să vă autentificați..",
        "plsauth3": "Vă rugăm să vă autentificați...",
        "authing0": "Autentificare, așteptați",
        "authing1": "Autentificare, așteptați.",
        "authing2": "Autentificare, așteptați..",
        "authing3": "Autentificare, așteptați...",
        "servconat": "Încercare de conectare la server",
        "incpaslog": "Parolă sau login incorect!",
        "settings": "SETĂRI",
        "enterip": "Introduceți IP",
        "enterport": "Introduceți portul",
        "sellang": "Selectați limba",
        "savelogpas": "Salvați loginul sau parola",
        "cancel": "Anulare",//11
        "close": "Închide",
        "alert": "Alertă!",
        "sure?": "Sunteți sigur că doriți să salvați modificările?",
        "yes": "Da",
        "no": "Nu",
        "sgtracker": "Căutare GPS Tracker",
        "sortby": "Sortare după",
        "name": "Nume",
        "battery": "Baterie",
        "gps": "GPS",
        "online": "Online"
    ]
]
