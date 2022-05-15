//
//  CategoriesModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import Foundation

struct MainCategoryModel: Codable {
    var mainCategoryEnum: String
    var subCategoryStrings: [SubCategoryModel]
}

struct SubCategoryModel: Codable {
    var subCategoryString: String
}
