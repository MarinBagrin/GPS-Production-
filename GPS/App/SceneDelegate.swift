//
//  SceneDelegate.swift
//  GPS
//
//  Created by Marin on 29.12.2024.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        print("Scene willConnectTo")
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = ViewController()
//        self.window = window
//        window.makeKeyAndVisible()
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("Scene willDidSisconect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//        if (g_server.isConnected == false) {
//            g_server.restartConnection()
//        }
        print("SceneDidBecomeActive")

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("SceneWillResignActive")

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

        print("Scene WillEnterForeground")

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        
        print("Scene DidEnterBackground")
       
    }


}
//func setAuthMenuAndActionTryingConnect() {
//    restartConnectionWithServer()
//    if (mainView.authentication.superview == nil) {
//        g_server.sendRequestUnAuth()
//        mainView.view.addSubview(mainView.authentication)
//    }
//    if (mainView.authentication.menuAuth.tryConnectServer.isHidden) {
//        mainView.authentication.menuAuth.setActiveTryingConnect()
//    }
//}
