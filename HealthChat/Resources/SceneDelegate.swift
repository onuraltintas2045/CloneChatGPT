//
//  SceneDelegate.swift
//  sdkTest
//
//  Created by Onur on 13.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let myWindow = UIWindow(windowScene: windowScene)
        let vc = ViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        myWindow.rootViewController = navigationController
        self.window = myWindow
        myWindow.makeKeyAndVisible()
    }

   


}

