//
//  AuthorModel.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit
import Kingfisher

let defaultImage: UIImage = UIImage(named: "unknown")!

struct Authors: Codable {
    var results: [Author]?
}

struct Author: Codable {
    var link: String?
    var bio: String?
    var description: String?
    var _id: String?
    var name: String?
}

struct Response: Codable {
    var query: Query?
}

struct Query: Codable {
    var pages: [Page]?
}

struct Page: Codable {
    var thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    var source: String?
}



struct AuthorQuotesResponse: Codable {
    var totalPages: Int?
    var results: [AuthorQuote]?
}

struct AuthorQuote: Codable {
    var content: String?
}

class AuthorQuoteVM {
    let rootAuthor: AuthorQuote
    
    init(rootAuthor: AuthorQuote) {
        self.rootAuthor = rootAuthor
    }
    
    var content: String {
        self.rootAuthor.content ?? "No Content"
    }
    
}


class AuthorCoreVM: Equatable {
    
    static func == (lhs: AuthorCoreVM, rhs: AuthorCoreVM) -> Bool {
        lhs.name == rhs.name && lhs.image == rhs.image
    }
    
    var state: CellState = .off
    var isChanging: Bool? = false
    var isDefaultPicture: Bool = false
    
    //var imageContain: UIImage?
    
    let rootAuthor: AuthorCore
    
    init(rootAuthor: AuthorCore) {
        self.rootAuthor = rootAuthor
    }

    var name: String {
        rootAuthor.name ?? "No Name"
    }
    
    var quotes: [QuoteCore] {
        if let relationship = rootAuthor.relationship,
           let quoteArr = relationship.allObjects as? [QuoteCore] {
            return quoteArr
        }
        else {
            return []
        }
    }
    
    lazy var image: UIImage = {
        if let imageData = rootAuthor.image,
           let image = UIImage(data: imageData) {
            return image
        }
        else {
            return defaultImage
        }
    }()
    
    func turnOn() {
        state = .on
    }
    
    func turnOff(isChanging: Bool) {
        self.state = .off
        self.isChanging = isChanging
    }
}

