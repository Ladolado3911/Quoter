//
//  TagCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel(frame: bounds)
        tagLabel.textColor = .black
        tagLabel.backgroundColor = .white
        return tagLabel
    }()
    
    var tagLabel2: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 5
//        frame = frame.inset(by: UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5))
        //sizeToFit()
        if let tagLabel2 = tagLabel2 {
            addSubview(tagLabel2)
            tagLabel2.frame = CGRect(x: 5,
                                     y: 0,
                                     width: bounds.width - 10,
                                     height: bounds.height)
//            tagLabel2.frame = tagLabel.frame.inset(by: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
        }
        //addSubview(tagLabel)
        //sizeToFit()
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.bounds.size.width = tagLabel.bounds.width
//        return layoutAttributes
//    }
    
}
