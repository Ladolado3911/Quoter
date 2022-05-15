//
//  File.swift
//  
//
//  Created by Lado Tsivtsivadze on 4/29/22.
//

import Foundation
import UIKit

enum Scheme: String {
    case http
    case https
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol EndpointProtocol {
    var scheme: Scheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}
