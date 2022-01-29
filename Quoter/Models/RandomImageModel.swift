//
//  RandomImageModel.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/29/22.
//

import UIKit

struct ImageResponse: Codable {
    var hits: [ImageItem]?
}
        
struct ImageItem: Codable {
    var largeImageURL: String?
}

