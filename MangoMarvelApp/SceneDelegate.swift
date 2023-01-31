//
//  SceneDelegate.swift
//  MangoMarvelApp
//
//  Created by MIGUEL ANGEL VELEZ SERRANO on 17/2/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = AppState.shared.coodinator.createMainNavigator()
        self.window = window
        window.makeKeyAndVisible()
    }
}

