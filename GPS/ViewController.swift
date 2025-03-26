//
//  ViewController.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//
import UIKit
import GoogleMaps

var mainView:ViewController!
var g_server = Socket()
class ViewController: UIViewController {
    var toolBar: ToolBar!
    var listMaps: ListMaps!
    var authentication: Authentication!
    var listTrackers: ListTrackers!
    var actionMenu: ActionMenu!
    var console:Console!
    var toolBarSlide: ToolBarSlide!
    var blurView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {

            while true {

                if (g_server.isConnected == false) {
                    g_server.connection.cancel()
                    g_server = Socket()
                    g_server.startConnection()
                    print("perezapysk")
                }
                sleep(5)

                if (!g_server.isLeasinig ) {g_server.recieveDataTrackers()
                print("recieveData")}

                
                //Thread.sleep(forTimeInterval: 0.5)

                DispatchQueue.main.async {
                    for map in mainView.listMaps.activeView.maps {
                        map.updateTrackers()
                    }
                    if ((self.toolBarSlide.searchTracker.text ?? "").isEmpty && STServer.filteredTrackers.isEmpty ) {
                        STServer.filteredTrackers = STServer.trackers
                    }
                    
                    mainView.toolBarSlide.listTrackers.reloadData()
                    CalloutView.openCallout?.updateData(tracker:((CalloutView.openCallout?.superview as! TrackerAnnotationView).annotation as! AnnotationTraker).tracker)
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func loadView() {
        super.loadView()
        print("Main loadView")
        mainView = self
        
        listMaps = ListMaps(superFrame:self.view.frame)
        
        // Создаем эффект размытия
        let blurEffect = UIBlurEffect(style: .dark) // .dark, .extraLight, .regular, .prominent
            
             // Создаем представление с этим эффектом
        
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = CGRect(x: 0, y: view.frame.height * 0.88, width: view.frame.width, height: view.frame.height) // Растягиваем на весь_экр
            blurView.layer.cornerRadius = 20
            blurView.clipsToBounds = true
            
             // Добавляем размытие на фон
             view.addSubview(blurView)
        
        //actionMenu = ActionMenu(frame: self.view.frame)
        //self.view.addSubview(actionMenu)
        toolBarSlide = ToolBarSlide(frame: self.view.frame)
        self.view.addSubview(toolBarSlide)
        //toolBar = ToolBar(superFrame: self.view.frame)
        //self.view.addSubview(toolBar)
        //Autorization
        authentication = Authentication(frame:self.view.frame)
        self.view.addSubview(authentication)
        //console = Console(frame: self.view.frame)
        //listTrackers = ListTrackers(frame: self.view.frame)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        //print(name! + " create")
        print("Progrizlosi View")
        
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
