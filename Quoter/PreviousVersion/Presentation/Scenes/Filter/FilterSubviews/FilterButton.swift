//
//  FilterButton.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit

class FilterButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .black
            }
            else {
                backgroundColor = .white
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.cornerRadius = bounds.height * 0.3
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
    }
}

