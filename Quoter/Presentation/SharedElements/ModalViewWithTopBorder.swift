//
//  ModalViewWithTopBorder.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/8/22.
//

import UIKit

class ModalViewWithTopBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 35
        layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        drawTopBorder(lineWidth: 2)
    }
}
