//
//  GalleryCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/14/22.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: GalleryCell.self)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeColors.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [DarkModeColors.black.cgColor, UIColor.clear.cgColor, DarkModeColors.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.5)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 1]
        return gradient
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func buildSubviews() {
        imageView.layer.addSublayer(gradientLayer)
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    func buildConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -bounds.height * 0.08125),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
}
