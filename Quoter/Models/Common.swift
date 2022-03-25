//
//  Common.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit

let exceptions = ["Buddha"]

enum CustomError: Error {
    case unwrapError
    case pageCountMismatchError
    case needsRecursion
    case couldNotGetContent
}

enum ImageType {
    case noPicture
    case author
}

final class Filters {
    static var filtersDict: [String: ClosedRange<Int>] = [:]
    
    static func getRangeOf(genre: String) -> ClosedRange<Int> {
        Filters.filtersDict[genre] ?? 1...1
    }
}

class FilterObject {
    let genre: String
    var pageRange: ClosedRange<Int>?
    
    init(genre: String, pageRange: ClosedRange<Int>?) {
        self.genre = genre
        self.pageRange = pageRange
    }
}
