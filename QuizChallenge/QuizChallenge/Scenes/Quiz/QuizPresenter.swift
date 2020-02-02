//
//  QuizPresenter.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation
protocol QuizPresentationLogic {
    func presentQuiz(response: Quiz.RequestQuiz.Response)
    func presentError()
}

class QuizPresenter: QuizPresentationLogic {
    
    weak var viewController: QuizDisplayLogic?
    
    //MARK: - Presentation Logic
    
    func presentQuiz(response: Quiz.RequestQuiz.Response) {
        let quiz = response.quiz
        
        let question = quiz.question ?? "-"
        guard let answers = quiz.answer else {
            presentError()
            return
        }
        
        let viewModel = Quiz.RequestQuiz.ViewModel(question: question, answers: answers)
        viewController?.displayQuiz(viewModel: viewModel)
    }
    func presentError() {
        viewController?.displayError()
    }
    
}
