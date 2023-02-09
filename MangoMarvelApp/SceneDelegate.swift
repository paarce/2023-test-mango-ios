//
//  SceneDelegate.swift
//  MangoMarvelApp
//
//  Created by MIGUEL ANGEL VELEZ SERRANO on 17/2/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let mainViperView = UIHostingController(rootView: ContentView())
        window.rootViewController = mainViperView//AppState.shared.coodinator.createMainNavigator()
        self.window = window
        window.makeKeyAndVisible()
    }
}

