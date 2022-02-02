//
//  AuthorModel.swift
//  jokeTest
//
//  Created by Lado Tsivtsivadze on 1/12/22.
//

import UIKit
import Kingfisher

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


class AuthorCoreVM: Equatable {
    
    static func == (lhs: AuthorCoreVM, rhs: AuthorCoreVM) -> Bool {
        lhs.name == rhs.name && lhs.image == rhs.image
    }
    
    var state: CellState = .off
    var isChanging: Bool? = false
    
    let rootAuthor: AuthorCore
    
    init(rootAuthor: AuthorCore) {
        self.rootAuthor = rootAuthor
    }
    
//    var link: String {
//        rootAuthor.link ?? "No Link"
//    }
//
//    var bio: String {
//        rootAuthor.bio ?? "No Bio"
//    }
//
//    var description: String {
//        rootAuthor.description ?? "No Description"
//    }
//
//    var id: String {
//        rootAuthor._id ?? "No Id"
//    }
//
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
    
    var image: UIImage {
        if let imageData = rootAuthor.image,
           let image = UIImage(data: imageData) {
            return image
        }
        else {
            return UIImage(named: "unknown")!
        }
    }
    
    func turnOn() {
        state = .on
    }
    
    func turnOff(isChanging: Bool) {
        self.state = .off
        self.isChanging = isChanging
    }
}

