//
//  Array+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/18/22.
//

import UIKit

var randomElementStorage: [Sound?] = []

extension Array where Element == Sound {

    func uniqueRandomElement() -> Sound? {
        var currentElement: Sound? = self.randomElement()
        
        while randomElementStorage.contains(currentElement) {
            currentElement = self.randomElement()!
        }
        randomElementStorage.append(currentElement)
        return currentElement
    }
}

