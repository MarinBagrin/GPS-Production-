//
//  AppDelegate.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//
import Foundation
import Network
import UIKit
import GoogleMaps
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyAUn4wVQyjs7Dz5-alcoWHLcZHv7FrR15U")
        // Адрес и порт сервера
        
        
//        DispatchQueue.global().async {
//            var currentMap = mainView.view.subviews[0]
//            var location: Double!
//            var zoom: Int!
//            if currentMap is GMSMapView {
//                var mapGoogle = currentMap as! GMSMapView
//                location = mapGoogle
//            }
//            for map in mainView.listMaps.activeView.maps {
//                if map.getUIView() == currentMap { continue }
//                
//            }
//        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

