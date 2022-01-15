//
//  AuthorsCellVM.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit

class AuthorCellVM {
    
    var state: CellState
    var isChanging: Bool? = false
    var image: UIImage
    //var color: UIColor
    
    init(state: CellState, image: UIImage) {
        self.state = state
        self.image = image
    }
    
    func turnOn() {
        state = .on
    }
    
    func turnOff(isChanging: Bool) {
        self.state = .off
        self.isChanging = isChanging
    }
}
