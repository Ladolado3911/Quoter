//
//  QuoteButtonView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/20/22.
//

import UIKit

class QuoteButtonView: UIView {
    
    let imageView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = ExploreIcons.quoteSignIcon
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 3
        backgroundColor = DarkModeColors.black
        layer.borderWidth = 0.5
        layer.borderColor = DarkModeColors.white.cgColor
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -8),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//            imageView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: bounds.width * 0.4533),
            imageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.324),
        ])
    }
    
    
}
