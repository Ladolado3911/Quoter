//
//  AuthorEntities.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/16/22.
//

import UIKit

protocol SectionProtocol {
    var sectionName: String { get set}
}

protocol AuthorAboutProtocol: Codable {
    var authorImageURLString: String { get set }
    var description: String { get set }
}

protocol AuthorQuotesForSectionProtocol: Codable, SectionProtocol {
    var quotes: [String] { get set }
}

protocol OtherAuthorsForSectionProtocol: Codable, SectionProtocol {
    var authors: [AuthorForSectionEntity] { get set }
}

protocol AuthorForSectionProtocol: Codable {
    var imageURL: String { get set }
    var name: String { get set }
}

protocol AuthorDataSourceInfoProtocol: Codable {
    var sectionCount: Int { get set }
    var cellIdentifiers: [String] { get set }
}

struct AuthorAboutEntity: Codable, AuthorAboutProtocol {
    var authorImageURLString: String
    var description: String
}

struct AuthorQuotesForSectionEntity: Codable, AuthorQuotesForSectionProtocol {
    var quotes: [String]
    var sectionName: String
}

struct OtherAuthorsForSectionEntity: Codable, OtherAuthorsForSectionProtocol {
    var authors: [AuthorForSectionEntity]
    var sectionName: String
    
    enum CodingKeys: CodingKey {
        case authors, sectionName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.authors = try container.decode([AuthorForSectionEntity].self, forKey: .authors)
        self.sectionName = try container.decode(String.self, forKey: .sectionName)
    }
}

struct AuthorForSectionEntity: Codable, AuthorForSectionProtocol {
    var imageURL: String
    var name: String
    
    enum CodingKeys: CodingKey {
        case imageURL, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

struct AuthorDataSourceInfoEntity: Codable, AuthorDataSourceInfoProtocol {
    var sectionCount: Int
    var cellIdentifiers: [String]
}
