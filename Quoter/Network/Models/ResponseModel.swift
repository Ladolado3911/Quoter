//
//  ResponseModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit

enum QuotieResponseEnum: Codable {
    case success(message: String)
    case failure(message: String)
}

struct QuotieResponse: Codable {
    var response: QuotieResponseEnum
}
