//
//  QuizAPI.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

enum QuizAPI {
    case getQuiz
}

extension QuizAPI: RESTRequest {
    var httpMethod: HTTPMethod {
        switch self {
        case .getQuiz:
            return .get
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://codechallenge.arctouch.com")!
    }
    
    var endpoint: String {
        switch self {
        case .getQuiz:
            return "/quiz/1"
        }
    }
}
