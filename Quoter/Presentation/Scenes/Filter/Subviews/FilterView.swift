//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

class FilterView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 25
        layer.masksToBounds = true
        //addBorders(edges: .top, color: DarkModeColors.white, inset: 0, thickness: 1)
        
    }
    
    override func draw(_ rect: CGRect) {
        let path = getTopBorderPath(lineWidth: 1)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = DarkModeColors.white.cgColor
        shapeLayer.position = .zero
        layer.addSublayer(shapeLayer)
    }
}
