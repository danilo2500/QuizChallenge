//
//  LoadUI.swift
//  Loader
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    //MARK: - UI Elements
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.color = MainColors.snow
        
        return activityIndicator
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "Loading..."
        label.textColor = MainColors.snow
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, label])
        
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var blackView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func didMoveToSuperview() {
        setupUI()
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupContraints()
    }
    
    private func setupContraints() {
        addSubview(blackView)
        
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        blackView.addSubview(stackView)
    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: blackView.topAnchor, constant: 24).isActive = true
        stackView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor, constant: -24).isActive = true
        stackView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: -24).isActive = true
    }
}
