//
//  DictumQuoteModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/8/22.
//

import UIKit

struct DictumQuoteModel: Codable {
    var text: String?
    var author: DictumAuthorModel?
}

struct DictumAuthorModel: Codable {
    var id: String?
    var name: String?
}

struct DictumQuoteVM {
    
    let rootModel: DictumQuoteModel
    
    var text: String {
        rootModel.text ?? "No Text"
    }
    
    var authorID: String {
        if let author = rootModel.author {
            if let id = author.id {
                return id
            }
            else {
                return "No Author ID"
            }
        }
        else {
            return "No Author to get id"
        }
    }
    
    var authorName: String {
        if let author = rootModel.author {
            if let name = author.name {
                return name
            }
            else {
                return "No Author ID"
            }
        }
        else {
            return "No Author to get name"
        }
    }
}
