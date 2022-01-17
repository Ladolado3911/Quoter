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

class AuthorVM {
    
    var state: CellState = .off
    var isChanging: Bool? = false
    
    let rootAuthor: Author
    
    init(rootAuthor: Author) {
        self.rootAuthor = rootAuthor
    }
    
    var link: String {
        rootAuthor.link ?? "No Link"
    }
    
//    var image: UIImage? {
//        do {
//            let url = URL(string: link)
//            if let url = url {
//                let data = try Data(contentsOf: url)
//                let image = UIImage(data: data)
//                return image
//            }
//            else {
//                return nil
//            }
//        }
//        catch {
//            return nil
//        }
//
//    }
    
    var bio: String {
        rootAuthor.bio ?? "No Bio"
    }
    
    var description: String {
        rootAuthor.description ?? "No Description"
    }
    
    var id: String {
        rootAuthor._id ?? "No Id"
    }
    
    var name: String {
        rootAuthor.name ?? "No Name"
    }
    
    func turnOn() {
        state = .on
    }
    
    func turnOff(isChanging: Bool) {
        self.state = .off
        self.isChanging = isChanging
    }
}

