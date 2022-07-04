//
//  MenuItem.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

struct MenuItem {
    let title: String
    let icon: UIImage
    var viewController: UIViewController
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected = true
    }
    
    mutating func deselect() {
        isSelected = false
    }
    
    mutating func switchVC(with vc: UIViewController) {
        viewController = vc
    }
}
