//
//  QuizWorker.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

protocol QuizWorkerManager {
    func getQuiz(completion: @escaping (Result<QuizModel, Error>) -> Void)
}

class QuizWorker {
    
    init(manager: QuizWorkerManager) {
        self.manager = manager
    }
    
    let manager: QuizWorkerManager
    
    func requestQuiz(completion: @escaping (Result<QuizModel, Error>) -> Void ) {
        manager.getQuiz(completion: completion)
    }
}
