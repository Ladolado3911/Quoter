//
//  AuthorsCellVM.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit

class AuthorCellVM {
    //var image: UIImage
    var state: CellState
    var color: UIColor
    
    init(state: CellState, color: UIColor) {
        self.state = state
        self.color = color
    }
    
//    mutating func turnOn() {
//        state = .on
//    }
//    
//    mutating func turnOff() {
//        state = .off
//    }
}
