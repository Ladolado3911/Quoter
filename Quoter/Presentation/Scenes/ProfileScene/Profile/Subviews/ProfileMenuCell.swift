//
//  ProfileMenuCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/28/22.
//

import UIKit

class ProfileMenuCell: UICollectionViewCell {
    
    lazy var vstack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.distribution = .fillProportionally
        vstack.spacing = 10
        vstack.isLayoutMarginsRelativeArrangement = true
        vstack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    let menuItemTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DarkModeColors.white
        label.text = "Gallery"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.lightBlack
        layer.applySketchShadow(color: DarkModeColors.black,
                                alpha: 0.7,
                                x: 1,
                                y: 4,
                                blur: 4,
                                spread: 0)
        layer.cornerRadius = 20
    }
    
    func buildSubviews() {
        vstack.addArrangedSubview(iconImageView)
        vstack.addArrangedSubview(menuItemTitleLabel)
        addSubview(vstack)
    }
    
    func buildConstraints() {
        NSLayoutConstraint.activate([
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstack.topAnchor.constraint(equalTo: topAnchor),
            vstack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vstack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
