//
//  FilterCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/9/22.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    lazy var iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = bounds.height * 0.2941
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = DarkModeColors.white
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var state: State = .off {
        didSet {
            if state == .on {
                iconImageView.image = iconImageView.image?.coloredSVG(color: DarkModeColors.black)
                titleLabel.textColor = DarkModeColors.black
                backgroundColor = DarkModeColors.white
            }
            else {
                iconImageView.image = iconImageView.image?.coloredSVG(color: DarkModeColors.white)
                titleLabel.textColor = DarkModeColors.white
                backgroundColor = DarkModeColors.lightBlack
            }
            if oldValue == state {
                if state == .off {
                    backgroundColor = DarkModeColors.lightBlack
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        backgroundColor = DarkModeColors.lightBlack
        layer.cornerRadius = bounds.height * 0.2941
        layer.applySketchShadow(color: DarkModeColors.black,
                                alpha: 0.7,
                                x: 1,
                                y: 4,
                                blur: 4,
                                spread: 0)
    }
    
    func buildSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    func buildConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: (-bounds.height * (1 - 0.769)) / 2),
            iconImageView.widthAnchor.constraint(equalToConstant: bounds.height * 0.769),
            iconImageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.769),
            
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
        ])
    }
}
