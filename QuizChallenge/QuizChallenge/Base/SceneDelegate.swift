//
//  SceneDelegate.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        setupInitialViewController()
    }
    
    private func setupInitialViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = QuizViewController()
        window.makeKeyAndVisible()
    }

}

