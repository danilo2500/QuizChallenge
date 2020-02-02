//
//  File.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

class QuizModel: Decodable {
    let question: String?
    let answer: [String]?
}
