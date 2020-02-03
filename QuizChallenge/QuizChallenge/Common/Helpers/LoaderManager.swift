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
    
    func showLoading(on view: UIView) {
        let loaderView = LoaderView(frame: view.frame)
        view.addSubview(loaderView)
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func dismissLoading(on view: UIView) {
        let loaderViews = view.subviews.filter({$0 is LoaderView})
        loaderViews.forEach({$0.removeFromSuperview()})
    }
}
