//
//  ScoreView.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 02/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

protocol ScoreViewDelegate: class {
    func scoreViewDidReset(_ scoreView: ScoreView)
    func scoreViewDidStart(_ scoreView: ScoreView)
    func scoreViewTimerDidFinish(_ scoreView: ScoreView)
    func scoreViewDidCompletePoints(_ scoreView: ScoreView)
}

class ScoreView: UIView {
    
    weak var delegate: ScoreViewDelegate?
    
    var maximumTime = TimeInterval(60*5) {
        didSet {
            updateTimerLabel(with: maximumTime)
        }
    }
    var maximumPoints = 0 {
        didSet {
            updateScore()
        }
    }
    var currentPoints = 0 {
        didSet{
            updateScore()
        }
    }
    
    //MARK: - Variables
    
    private(set) var timeLeft = TimeInterval(0)
    private var timer = Timer()
    
    //MARK: - UI Elements
    
    private lazy var scoreLabel: UILabel = {
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
    
    private lazy var button: MainButton = {
        let button = MainButton()
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.setTitle("Start", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, button])
        
        stackView.spacing = 16
        stackView.axis = .vertical
        
        return stackView
    }()
    
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
    
    func startTimer() {
        updateTimerLabel(with: maximumTime)
        timeLeft = maximumTime
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerDidTick()
        }
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
        dateComponentsFormatter.zeroFormattingBehavior = .pad
        
        let textFormatted = dateComponentsFormatter.string(from: timeInterval)
        
        timerLabel.text = textFormatted
    }
    
    private func updateScore() {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 2

        let maximumPointsText = numberFormatter.string(from: NSNumber(value: maximumPoints)) ?? "-"
        let currentPointsText = numberFormatter.string(from: NSNumber(value: currentPoints)) ?? "-"
        
        scoreLabel.text = currentPointsText + "/" + maximumPointsText
        
        if currentPointsText >= maximumPointsText {
            timer.invalidate()
            delegate?.scoreViewDidCompletePoints(self)
        }
    }
    
    @objc private func didTapButton() {
        button.setTitle("Reset", for: .normal)
        
        if timer.isValid {
            currentPoints = 0
            delegate?.scoreViewDidReset(self)
        } else {
            delegate?.scoreViewDidStart(self)
        }
        startTimer()
    }
}
