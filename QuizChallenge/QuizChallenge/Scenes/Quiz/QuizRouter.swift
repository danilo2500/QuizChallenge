//
//  QuizRouter.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//


import UIKit

protocol QuizRoutingLogic {}

protocol QuizDataPassing {
    var dataStore: QuizDataStore? { get }
}

class QuizRouter: NSObject, QuizRoutingLogic, QuizDataPassing {
    weak var viewController: QuizViewController?
    var dataStore: QuizDataStore?
}
