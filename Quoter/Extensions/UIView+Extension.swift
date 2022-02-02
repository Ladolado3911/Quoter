//
//  UIView+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

extension UIView {
    
    var initialFrame: CGRect {
        CGRect(x: bounds.width / 2, y: bounds.height / 2, width: 0, height: 0)
    }
}
