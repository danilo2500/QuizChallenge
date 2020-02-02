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
    let cellIdentifier = String(describing: UITableViewCell.self)
    
    //MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.isHidden = true
        }
    }
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        }
        
    }
    
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
        
        requestQuizData()
    }
    
    //MARK: - Private Functions
    
    private func requestQuizData() {
        LoaderManager.shared.showLoading()
        
        let request = Quiz.RequestQuiz.Request()
        interactor?.requestQuiz(request: request)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func textFieldDidChangeEditing(_ sender: Any) {
        guard let text = textField.text else { return }
        
        if answers.contains(text) && !correctAnswers.contains(text) {
            correctAnswers.append(text)
            
            tableView.beginUpdates()
            let indexPath = IndexPath(row: correctAnswers.endIndex - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            textField.text = nil
        }
    }
    
    
}

//MARK: - Display Logic

extension QuizViewController: QuizDisplayLogic {
    
    func displayQuiz(viewModel: Quiz.RequestQuiz.ViewModel) {
        LoaderManager.shared.dismissLoading()
        
        stackView.isHidden = false
        
        questionLabel.text = viewModel.question
        answers = viewModel.answers
    }
    
    func displayError() {
        LoaderManager.shared.dismissLoading()
        
        let alert = UIAlertController(title: "Error", message: "An unexpected error has occurred", preferredStyle: .alert)
        
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
