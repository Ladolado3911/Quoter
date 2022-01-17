//
//  Endpoints.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/8/22.
//

import UIKit

struct JokeEndpoints {
    static var joke: URL? {
        URL(string: "https://v2.jokeapi.dev/joke/Miscellaneous,Christmas?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=twopart")
    }
}
