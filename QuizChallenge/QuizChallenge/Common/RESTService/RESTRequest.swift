//
//  RequestProtocol.swift
//  QuizChallenge
//
//  Created by Danilo Henrique on 01/02/20.
//  Copyright © 2020 Danilo Henrique. All rights reserved.
//

import Foundation

protocol RESTRequest {
    var httpMethod: HTTPMethod { get }
    var baseURL: URL { get }
    var endpoint: String { get }
}
