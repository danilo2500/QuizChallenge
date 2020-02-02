//
//  QuizViewController.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import UIKit

protocol QuizDisplayLogic: class {
    func displayQuiz(viewModel: Quiz.RequestQuiz.ViewModel)
    func displayError()
}

class QuizViewController: UIViewController {
    
    var interactor: QuizBusinessLogic?
    var router: (NSObjectProtocol & QuizRoutingLogic & QuizDataPassing)?
    
    //MARK: - Constants
    
    private let cellIdentifier = String(describing: UITableViewCell.self)
    private let maximumTime = TimeInterval(60*5)
    
    //MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.isHidden = true
        }
    }
    @IBOutlet weak var questionLabel: UILabel! {
        didSet {
            questionLabel.font = MainFonts.largeTitle
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.isEnabled = false
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.tableFooterView = UIView()
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
        
    }
    @IBOutlet weak var scoreView: ScoreView! {
        didSet {
            scoreView.isHidden = true
            scoreView.delegate = self
            scoreView.maximumTime = maximumTime
        }
    }
    @IBOutlet weak var scoreViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Private Variables
    
    private var answers: [String] = []
    private var correctAnswers: [String] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = QuizInteractor()
        let presenter = QuizPresenter()
        let router = QuizRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizerToDismissKeyboard()
        registerForKeyboardNotifications()
        requestQuizData()
    }
    
    //MARK: - Private Functions
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeState(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeState(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeState(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc private func keyboardWillChangeState(notification: NSNotification) {
        let keyboardUserInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let keyboardHeight = keyboardUserInfo?.cgRectValue.height else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.scoreViewBottomConstraint.constant = keyboardHeight
        } else {
            self.scoreViewBottomConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }
    
    private func requestQuizData() {
        LoaderManager.shared.showLoading(on: view)
        
        let request = Quiz.RequestQuiz.Request()
        interactor?.requestQuiz(request: request)
    }
    
    private func startGame() {
        textField.isEnabled = true
        textField.becomeFirstResponder()
        
        correctAnswers.removeAll()
        tableView.reloadData()
        
        scoreView.currentPoints = 0
        scoreView.startTimer()
    }
    
    private func showPlayerWinAlert() {
        let title = "Congratilations"
        let message = "Good job! You found all the answers on time. Keep up with the great work"
        let actionTitle = "Play Again"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.startGame()
        }
        
        alert.addAction(playAgainAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showPlayerLostAlert() {
        let title = "Time Finished"
        let message = "Sorry, time is up! You got \(correctAnswers.count) out of \(answers.count) answers."
        let actionTitle = "Try Again"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let playAgainAction = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.startGame()
        }
        alert.addAction(playAgainAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func textFieldDidChangeEditing(_ sender: Any) {
        guard let text = textField.text else { return }
        
        if answers.contains(text) && !correctAnswers.contains(text) {
            correctAnswers.insert(text, at: 0)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.endUpdates()
            
            tableView.estimatedRowHeight = 85.0
            tableView.rowHeight = UITableView.automaticDimension
            
            textField.text = nil
            scoreView.currentPoints = correctAnswers.count
        }
    }
}

//MARK: - Display Logic

extension QuizViewController: QuizDisplayLogic {
    
    func displayQuiz(viewModel: Quiz.RequestQuiz.ViewModel) {
        LoaderManager.shared.dismissLoading(on: view)
        
        stackView.isHidden = false
        scoreView.isHidden = false
        
        answers = viewModel.answers
        questionLabel.text = viewModel.question
        scoreView.maximumPoints = answers.count
    }
    
    func displayError() {
        LoaderManager.shared.dismissLoading(on: view)
        
        let alert = UIAlertController(title: "Error", message: "An unexpected error has occurred.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.requestQuizData()
        }
        alert.addAction(tryAgainAction)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView Delegate

extension QuizViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = correctAnswers[indexPath.row]
        return cell
    }
}

//MARK: - ScoreView Delegate

extension QuizViewController: ScoreViewDelegate {
    func scoreViewDidReset(_ scoreView: ScoreView) {
        startGame()
    }
    
    func scoreViewDidStart(_ scoreView: ScoreView) {
        startGame()
    }
    
    func scoreViewDidCompletePoints(_ scoreView: ScoreView) {
        textField.isEnabled = false
        showPlayerWinAlert()
    }
    
    func scoreViewTimerDidFinish(_ scoreView: ScoreView) {
        let playerIsWinner = correctAnswers.count == answers.count
        
        if playerIsWinner {
            showPlayerWinAlert()
        } else {
            showPlayerLostAlert()
        }
    }
    
}
