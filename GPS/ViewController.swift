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
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = self
        
        listMaps = ListMaps(superFrame:self.view.frame)
        listTrackers = ListTrackers(frame: self.view.frame)
        //ToolBar
        actionMenu = ActionMenu(frame: self.view.frame)
        self.view.addSubview(actionMenu)
        toolBar = ToolBar(superFrame: self.view.frame)
        self.view.addSubview(toolBar)
        //Autorization
        authentication = Authentication(frame:self.view.frame)
        self.view.addSubview(authentication)
        
        
    }
    override func loadView() {
        super.loadView()
//        let versionLabel = UILabel(frame: CGRect(x:20, y: 10, width: 200, height: 20))
//        versionLabel.text = "Right and Left"
//        view.addSubview(versionLabel)
        print("Main loadView")
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

    



