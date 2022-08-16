//
//  MaskedView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/11/22.
//

import UIKit

class RatingView: UIView {
    
    var starsCount: CGFloat = 5
    var rating: CGFloat = 0 
    var orangeViewCoefficient: CGFloat = 0 {
        didSet {
            orangeViewWidth = bounds.width * orangeViewCoefficient
        }
    }
    var orangeViewWidth: CGFloat = 0 {
        didSet {
            orangeView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: orangeViewWidth,
                                      height: frame.height)
        }
    }
    
    lazy var orangeView: UIView = {
//        let width = bounds.width * 0.7
//        let newRect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        let yellow = UIView()
        yellow.backgroundColor = .orange
        print("2")
        return yellow
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .orange.withAlphaComponent(0.2)
        addSubview(orangeView)
    }

    func drawStar(path: UIBezierPath, starIndex: Int, starWidth: CGFloat, cornerRadius: CGFloat, rotation: CGFloat) {
        
        let incrementX: CGFloat = starWidth
        let minX: CGFloat = CGFloat(starIndex) * incrementX
        let centerX = minX + (starWidth / 2)
        
        let center = CGPoint(x: centerX, y: bounds.height / 2)
        let r = starWidth / 2
        let rc = cornerRadius
        let rn = r * 0.95 - rc

        var cangle = rotation
        for i in 1 ... 5 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * cos((cangle - 72) * .pi / 180), y: cc.y + rc * sin((cangle - 72) * .pi / 180))

            if i == 1 {
                path.move(to: p)
            }
            else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(withCenter: cc, radius: rc, startAngle: (cangle - 72) * .pi / 180, endAngle: (cangle + 72) * .pi / 180, clockwise: true)

            cangle += 144
        }
        
        //path.close()
        //return path
    }
    
    func drawRating() -> UIBezierPath {
        let path = UIBezierPath()
        let starWidth: CGFloat = bounds.width / starsCount
        for starIndex in 0..<Int(starsCount) {
            drawStar(path: path, starIndex: starIndex, starWidth: starWidth, cornerRadius: 0.5, rotation: 54)
        }
        return path
    }

    func mask() {
        let maskLayer = CAShapeLayer() //create the mask layer

        // Give the mask layer the path you just draw
        //maskLayer.path = getStarPath(cornerRadius: 0, rotation: 54).cgPath
        maskLayer.path = drawRating().cgPath
        // Fill rule set to exclude intersected paths
        maskLayer.fillRule = .nonZero

        // By now the mask is a rectangle with a star cut out of it. Set the mask to the view and clip.
        layer.mask = maskLayer
    
        clipsToBounds = true

        alpha = 0.8
        backgroundColor = UIColor.orange.withAlphaComponent(0.7)
    }

}
