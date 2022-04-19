//
//  ExploreCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        //let frame = CGRect(x: 0, y: 44, width: bounds.width, height: bounds.height * 0.8)
        gradient.frame = bounds
        gradient.colors = [DarkModeColors.black.cgColor, UIColor.clear.cgColor, DarkModeColors.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 0.6161, 1]
        return gradient
    }()
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.addSublayer(gradientLayer)
        return imageView
    }()
    
    let authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.text = "Albert Einstein"
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorNameLabel
    }()
    
    let quoteContentLabel: UILabel = {
        // 30 char is min
        // 56 char is max
        let quoteContentLabel = UILabel()
        quoteContentLabel.numberOfLines = 2
        quoteContentLabel.addLineHeight(lineHeight: Constants.screenHeight * 0.0616)
        quoteContentLabel.font = Fonts.businessFonts.goodTimes.regular(size: Constants.screenHeight * 0.03)
        quoteContentLabel.textColor = .white
        quoteContentLabel.textAlignment = .center
        quoteContentLabel.text = "Play by the rules, but be ferocious"
        quoteContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return quoteContentLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imgView)
        //addSubview(authorNameLabel)
        addSubview(quoteContentLabel)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            quoteContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.0563),
            quoteContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.screenWidth * 0.0468),
            quoteContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenWidth * 0.0468),
            
            
        
        ])
    }
}
