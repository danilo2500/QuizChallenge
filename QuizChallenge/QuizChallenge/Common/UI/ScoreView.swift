//
//  ScoreView.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 02/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    //MARK: - UI Elements
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Loading..."
        label.textColor = MainColors.snow
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Loading..."
        label.textColor = MainColors.snow
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scoreLabel, timerLabel])
        
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
}
