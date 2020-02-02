//
//  QuizInteractor.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//
//

import Foundation

protocol QuizBusinessLogic {
    func requestQuiz(request: Quiz.RequestQuiz.Request)
}

protocol QuizDataStore {
    
}

class QuizInteractor: QuizBusinessLogic, QuizDataStore {
    
    var presenter: QuizPresentationLogic?
    var worker = QuizWorker(manager: QuizAPIManager())
    
    func requestQuiz(request: Quiz.RequestQuiz.Request) {
        worker.requestQuiz { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let quiz):
                let response = Quiz.RequestQuiz.Response(quiz: quiz)
                self.presenter?.presentQuiz(response: response)
            case .failure:
                self.presenter?.presentError()
            }
        }
    }
}
