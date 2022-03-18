//
//  Array+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/18/22.
//

import UIKit

var randomElementStorage: [Sound?] = []
var randomIntElementStorage: [Int?] = []

extension Array where Element == Sound {

    func uniqueRandomElement(isEnabling: Bool) -> Sound? {
        if isEnabling {
            var currentElement: Sound? = self.randomElement()!
        
            if randomElementStorage.count == Sound.allCases.filter { $0.rawValue.contains("music") }.count {
                randomElementStorage.leaveOnlyLast()
            }
            while randomElementStorage.contains(currentElement) {
                currentElement = self.randomElement()!
            }
            randomElementStorage.append(currentElement)
            return currentElement
        }
        return nil
    }
}

extension Array {
    mutating func leaveOnlyLast() {
        for item in 0..<self.count - 1 {
            if item >= self.count {
                continue
            }
            self.remove(at: item)
        }
    }
}

extension Array where Element == Int {

    func uniqueRandomElement() -> Int? {
        var currentElement: Int? = self.randomElement()
        if randomIntElementStorage.count == ImageEndpoints.pages.count {
            randomIntElementStorage.removeAll()
        }
        while randomIntElementStorage.contains(currentElement) {
            currentElement = self.randomElement()!
        }
        randomIntElementStorage.append(currentElement)
        return currentElement
    }
}

