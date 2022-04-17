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
        gradient.frame = bounds
        gradient.colors = [DarkModeColors.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 0.6161]
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
        // 28 char is min
        // 56 char is max
        let quoteContentLabel = UILabel()
        quoteContentLabel.numberOfLines = 2
        quoteContentLabel.addLineHeight(lineHeight: 35)
        quoteContentLabel.font = UIFont(name: "Arial", size: 23)
        quoteContentLabel.textColor = .white
        quoteContentLabel.textAlignment = .center
        quoteContentLabel.text = "The only real valuable thing is intuition"
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
        addSubview(authorNameLabel)
        addSubview(quoteContentLabel)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            quoteContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            quoteContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            quoteContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            
        
        ])
    }
}
