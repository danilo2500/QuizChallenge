//
//  QuestionAPIManager.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

class QuizAPIManager: QuizWorkerManager {
    
    func getQuiz(completion: @escaping (Result<QuizModel, Error>) -> Void) {

        let restService = RESTService<QuizAPI>()
        
        restService.request(.getQuiz) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
