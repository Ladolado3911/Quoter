//
//  ArrowButtonView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/16/22.
//

import UIKit

enum Direction {
    case left
    case right
    case up
    case down
}

class ArrowButton: UIButton {
    
    var direction: Direction = .left

    let rotate180 = CGAffineTransform(rotationAngle: Double.pi / 1)
    let rotate90 = CGAffineTransform(rotationAngle: Double.pi / 2)
    let rotateMinus90 = CGAffineTransform(rotationAngle: -Double.pi / 2)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(ExploreIcons.arrowIconThin, for: .normal)
        imageView?.contentMode = .scaleAspectFill
    }
    
    convenience init(direction: Direction) {
        self.init(frame: .zero)
        switch direction {
        case .left:
            break
        case .right:
            setImage(imageView?.image?.withHorizontallyFlippedOrientation(), for: .normal)
        case .up:
            imageView?.transform = rotate90
        case .down:
            imageView?.transform = rotateMinus90
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
    }
}
