//
//  ProfileMenuCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/28/22.
//

import UIKit

class ProfileMenuCell: UICollectionViewCell {
    
    let rectView: UIView = {
        let rectView = UIView()
        rectView.backgroundColor = DarkModeColors.lightBlack
        rectView.layer.applySketchShadow(color: DarkModeColors.black,
                                         alpha: 0.7,
                                         x: 1,
                                         y: 4,
                                         blur: 4,
                                         spread: 0)
        rectView.layer.cornerRadius = 20
        rectView.translatesAutoresizingMaskIntoConstraints = false
        return rectView
    }()
    
    lazy var vstack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.distribution = .fillProportionally
        vstack.spacing = 10
        vstack.alignment = .center
        vstack.isLayoutMarginsRelativeArrangement = true
        let inset = Constants.screenHeight * 0.0215
        vstack.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    let menuItemTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DarkModeColors.white
        label.text = "Gallery"
        label.font = UIFont.systemFont(ofSize: Constants.screenHeight * 0.02375, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    func buildSubviews() {
        addSubview(rectView)
        vstack.addArrangedSubview(iconImageView)
        vstack.addArrangedSubview(menuItemTitleLabel)
        addSubview(vstack)
    }
    
    func buildConstraints() {
        NSLayoutConstraint.activate([
            
            rectView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rectView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            rectView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            vstack.leadingAnchor.constraint(equalTo: rectView.leadingAnchor),
            vstack.topAnchor.constraint(equalTo: rectView.topAnchor),
            vstack.trailingAnchor.constraint(equalTo: rectView.trailingAnchor),
            vstack.bottomAnchor.constraint(equalTo: rectView.bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
//            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
        ])
    }
}
