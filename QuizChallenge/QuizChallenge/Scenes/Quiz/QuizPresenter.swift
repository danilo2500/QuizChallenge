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
    
    func presentQuiz(response: Quiz.RequestQuiz.Response) {
        
    }
    func presentError() {
        
    }
    
}
