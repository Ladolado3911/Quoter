//
//  UserCredentialsModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/27/22.
//

import UIKit

struct UserCredentials: Codable {
    var email: String
    var password: String
    var isMailVerified: Bool?
}

struct UserModel: Codable {
    var idString: String
    var email: String
    var password: String
}
