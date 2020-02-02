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
    
    //MARK: - Outlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var interactor: QuizBusinessLogic?
    var router: (NSObjectProtocol & QuizRoutingLogic & QuizDataPassing)?
    
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
        
        requestQuestionData()
    }
    
    //MARK: - Private Functions
    
    private func requestQuizData() {
        LoaderManager.shared.showLoading()
        
        let request = Quiz.RequestQuiz.Request()
        interactor?.requestQuiz(request: request)
    }
    
}

extension QuizViewController: QuizDisplayLogic {
    
    func displayQuiz(viewModel: Quiz.RequestQuiz.ViewModel) {
        
    }
    
    func displayError() {
        
    }
}
