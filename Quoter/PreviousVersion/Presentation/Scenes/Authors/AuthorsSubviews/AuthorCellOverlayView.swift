//
//  AuthorCellOverlayView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/11/22.
//

import UIKit

class AuthorCellOverlayView: UIView {
    
    private var radius: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, radius: CGFloat) {
        self.init(frame: frame)
        self.radius = radius
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let radius = radius else {
            print("radius is nil")
            return
        }
        drawFirstShape(radius: radius)
        drawSecondShape(radius: radius)
        
    }
    
    private func drawFirstShape(radius: CGFloat) {
        let path1 = UIBezierPath()
        
        let controlPoint1 = CGPoint(x: radius / 5,
                                    y: 0)

        // draw shape 1
        
        path1.move(to: .zero)
        path1.addLine(to: CGPoint(x: path1.currentPoint.x,
                                 y: path1.currentPoint.y - radius))
        
        path1.addQuadCurve(to: CGPoint(x: path1.currentPoint.x + radius,
                                      y: path1.currentPoint.y + radius),
                          controlPoint: controlPoint1)

        path1.close()
        
        let fillColor = UIColor.white
        fillColor.setFill()
        path1.fill()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path1.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    private func drawSecondShape(radius: CGFloat) {
        let path1 = UIBezierPath()

        let controlPoint = CGPoint(x: self.bounds.width - (radius / 5),
                                    y: 0)
        
        // draw shape 1
        
        path1.move(to: .zero)
        path1.move(to: CGPoint(x: self.bounds.width, y: path1.currentPoint.y))
        
        path1.addLine(to: CGPoint(x: path1.currentPoint.x,
                                  y: path1.currentPoint.y - radius))
        
        path1.addQuadCurve(to: CGPoint(x: path1.currentPoint.x - radius,
                                       y: path1.currentPoint.y + radius),
                          controlPoint: controlPoint)

        path1.close()
        
        let fillColor = UIColor.white
        fillColor.setFill()
        path1.fill()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path1.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        self.layer.addSublayer(shapeLayer)
        
        
    }
}
