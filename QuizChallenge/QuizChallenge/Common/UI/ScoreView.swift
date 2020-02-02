//
//  ScoreView.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 02/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

protocol ScoreViewDelegate: class {
    func scoreView(_ scoreView: ScoreView, didTapButton button: UIButton)
    func scoreViewTimerDidFinish(_ scoreView: ScoreView)
}

class ScoreView: UIView {
    
    weak var delegate: ScoreViewDelegate?
    
//    var maximumTime = TimeInterval(60*5)
    var maximumTime = TimeInterval(1    )
    
    //MARK: - Private Variables
    
    private(set) var timeLeft = TimeInterval(0)
    private var timer = Timer()
    
    //MARK: - UI Elements
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = MainFonts.largeTitle
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = MainFonts.largeTitle
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scoreLabel, timerLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    lazy var button: MainButton = {
        let button = MainButton()
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, button])
        
        stackView.spacing = 16
        stackView.axis = .vertical
        
        return stackView
    }()
    
    //MARK: - Functions
    
    func startTimer() {
        updateTimerLabel(with: maximumTime)
        timeLeft = maximumTime
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerDidTick()
        }
    }
    
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
        backgroundColor = MainColors.snow
        updateTimerLabel(with: maximumTime)
        setupContraints()
    }
    
    private func setupContraints() {
        addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    private func timerDidTick() {
        self.timeLeft = self.timeLeft.advanced(by: -1)
        
        self.updateTimerLabel(with: self.timeLeft)
        
        if self.timeLeft <= 0 {
            self.timer.invalidate()
            self.delegate?.scoreViewTimerDidFinish(self)
        }
    }
    
    private func updateTimerLabel(with timeInterval: TimeInterval) {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.minute, .second]
        
        let textFormatted = dateComponentsFormatter.string(from: timeInterval)
        
        timerLabel.text = textFormatted
    }
    
    @objc private func didTapButton() {
        delegate?.scoreView(self, didTapButton: button)
    }
}
