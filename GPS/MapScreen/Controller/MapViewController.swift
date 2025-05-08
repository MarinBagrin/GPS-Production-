//
//  ViewController.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//
import UIKit
import GoogleMaps
var lang:Language = .ru

class MapViewController: UIViewController {
    var mapViewModel:MapViewModel
    var appleMapView:AppleMapMnagerView!
    var toolBarSlideView:ToolBarSlideView!
    var authenticationView:AuthenticationView!
    var actionMenu:ActionMenu!
    //var actionMenu:ActionMenu!
    var coordinator:MapCoordinator?
    init(coordinator:MapCoordinator) {
        self.coordinator = coordinator
        mapViewModel = MapViewModel(repositories: coordinator.repositories)
        super.init(nibName: nil, bundle: nil)
        mapViewModel.onOpenSettings = { [weak self] in
            self?.coordinator?.showSettingVC()
        }
    }
    deinit {
        print("deinit MapViewController")

        coordinator?.removeFromSuperCoordinator()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appleMapView = AppleMapMnagerView(self.view.frame,viewModel: mapViewModel)
        toolBarSlideView = ToolBarSlideView(frame: self.view.frame,viewModel: mapViewModel)
        authenticationView = AuthenticationView(frame: self.view.frame,viewModel: mapViewModel)
        actionMenu = ActionMenu(viewModel: mapViewModel)
        setupUI()
        
        actionMenu.tappedArchiveButton = { self.coordinator?.showArchieveVC(viewModel: self.mapViewModel)}
    }
    
private func setupUI() {
    self.view.addSubview(appleMapView.map)
    self.view.addSubview(actionMenu)
    self.view.addSubview(toolBarSlideView)
    self.view.addSubview(authenticationView)

    
    actionMenu.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        actionMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        actionMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
    ])


}
    override func loadView() {
        super.loadView()
        print("Main loadView")
        
        //authenticationView.showScreenSettings = {self.present(self.settingsController, animated: true)}
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    DispatchQueue.global().async {
//
//        while true {
//
//            if (g_server.isConnected == false) {
//                DispatchQueue.main.async {
//                    setAuthMenuAndActionTryingConnect()
//                }
//                g_server.connection.cancel()
//                g_server = Socket()
//                g_server.startConnection()
//                print("perezapysk")
//            }
//            sleep(1)
//            if (!g_server.isLeasinig ) {g_server.recieveDataTrackers()
//            print("recieveData")}
//
//            
//            //Thread.sleep(forTimeInterval: 0.5)
//
//            DispatchQueue.main.async {
//                for map in mainView.listMaps.activeView.maps {
//                    map.updateTrackers()
//                }
//                if ((self.toolBarSlide.searchTracker.text ?? "").isEmpty && STServer.filteredTrackers.isEmpty ) {
//                    STServer.filteredTrackers = STServer.trackers
//                }
//                
//                mainView.toolBarSlide.listTrackers.reloadData()
//                CalloutView.openCallout?.updateData(tracker:((CalloutView.openCallout?.superview as! TrackerAnnotationView).annotation as! AnnotationTraker).tracker)
//            }
//        }
//    }
//}
