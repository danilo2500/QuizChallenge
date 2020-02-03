//
//  QuizModels.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

enum Quiz {
    // MARK: Use cases
    
    enum RequestQuiz {
        struct Request {}
        struct Response {
            let quiz: QuizModel
        }
        struct ViewModel {
            let question: String
            let answers: [String]
        }
    }
}
