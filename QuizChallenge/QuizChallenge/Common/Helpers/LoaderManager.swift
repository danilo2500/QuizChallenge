//
//  LoaderManager.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

class LoaderManager {
    
    static let shared = LoaderManager()
    
    private init() {}
    
    func showLoading() {
        guard let window = UIApplication.shared.windows.last else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        let loaderView = LoaderView(frame: window.frame)
        rootViewController.view.addSubview(loaderView)
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor).isActive = true
    }
    
    func dismissLoading() {
        guard let window = UIApplication.shared.windows.last else { return }
        guard let rootViewController = window.rootViewController else { return }
        
        let loaderViews = rootViewController.view.subviews.filter({$0 is LoaderView})
        loaderViews.forEach({$0.removeFromSuperview()})
    }
}
