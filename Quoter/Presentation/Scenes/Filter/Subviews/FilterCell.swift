//
//  FilterCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/9/22.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    let iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = DarkModeColors.white
        label.font = LibreBaskerville.styles.regular(size: 20)
        //label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.lightBlack
        layer.cornerRadius = bounds.height * 0.2941
        layer.applySketchShadow(color: DarkModeColors.black,
                                alpha: 0.7,
                                x: 1,
                                y: 4,
                                blur: 4,
                                spread: 0)
    }
    
    func buildSubviews() {
        //addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    func buildConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
}
