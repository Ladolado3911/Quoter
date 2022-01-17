//
//  JokeModel.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/8/22.
//

import UIKit

struct Joke: Codable {
    var setup: String?
    var delivery: String?
    var safe: Bool?
}

struct JokeVM {
    let rootJoke: Joke!
    
    var setup: String {
        rootJoke.setup ?? "No setup"
    }
    
    var delivery: String {
        rootJoke.delivery ?? "No delivery"
    }
    
    var safe: Bool {
        rootJoke.safe ?? false
    }
}

