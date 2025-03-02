//
//  ViewController.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//
import UIKit
import GoogleMaps

var mainView:ViewController!

class ViewController: UIViewController {
    var toolBar: ToolBar!
    var listMaps: ListMaps!
    var authentication: Authentication!
    var listTrackers: ListTrackers!
    var actionMenu: ActionMenu!
    var connectWithServer = Socket()
    var console:Console!
    var toolBarSlide: ToolBarSlide!
    var blurView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = self
        
        listMaps = ListMaps(superFrame:self.view.frame)
        listTrackers = ListTrackers(frame: self.view.frame)
        
        // Создаем эффект размытия
            let blurEffect = UIBlurEffect(style: .light) // .dark, .extraLight, .regular, .prominent
        
             // Создаем представление с этим эффектом
        
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = CGRect(x: 0, y: view.frame.height * 0.915, width: view.frame.width, height: view.frame.height) // Растягиваем на весь_экр
            blurView.layer.cornerRadius = 20
            blurView.clipsToBounds = true
            
             // Добавляем размытие на фон
             view.addSubview(blurView)
        
        actionMenu = ActionMenu(frame: self.view.frame)
        self.view.addSubview(actionMenu)
        toolBarSlide = ToolBarSlide(frame: self.view.frame)
        self.view.addSubview(toolBarSlide)
        //toolBar = ToolBar(superFrame: self.view.frame)
        //self.view.addSubview(toolBar)
        //Autorization
        //authentication = Authentication(frame:self.view.frame)
        //self.view.addSubview(authentication)
        //console = Console(frame: self.view.frame)
        
        
    }
    override func loadView() {
        super.loadView()
        print("Main loadView")

//        connectWithServer.startConnection()
//        DispatchQueue.global().async {
//            while true {
//                Thread.sleep(forTimeInterval: 3)
//                
//                for tracker in STServer.trackers {
//                    tracker.lat += Double.random(in: -1...1)
//                    tracker.long += Double.random(in: -1...1)
//                }
//                //
//                DispatchQueue.main.async {
//                    for map in mainView.listMaps.activeView.maps {
//                        map.updateTrackers()
//                    }
//                }
////              self.connectWithServer.sendRequest()
//                print("----")
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Main viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Main viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Main viewWillDisppear")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        print("Main viewDidDisappear")
    }
}

    



//var message = DataMessage()
//        message.id = "0"
//        message.value = "value: 0"
//        do {
//            let serialized = try message.serializedData()
//            print(serialized)
//
//            let deserialized = try DataMessage(serializedData: serialized)
//            print(deserialized)
//        }
//        catch {
//            print("error 0 manual")
//        }
