//
//  MainButton.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 02/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

class MainButton: UIButton {
    
    //MARK: - Object LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //MARK: - Private Functions
    
    private func setupUI() {
        backgroundColor = MainColors.orange
        titleLabel?.font = MainFonts.button
        layer.cornerRadius = 6
    }
}
