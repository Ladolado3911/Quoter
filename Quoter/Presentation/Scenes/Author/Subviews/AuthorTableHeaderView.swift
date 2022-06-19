//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/16/22.
//

import UIKit

class AuthorTableHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = .gray
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let aboutLabel: UILabel = {
        let aboutLabel = UILabel()
        aboutLabel.text = "About"
        aboutLabel.textAlignment = .center
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        return aboutLabel
    }()
    
    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 5
        descLabel.text = "Lorem  volutpat posuere dictum. Etiam in dictum urna Lorem  volutpat posuere dictum. Etiam in dictum urna"
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        return descLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
        addSubview(aboutLabel)
        addSubview(descLabel)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.screenWidth * 0.0468),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenWidth * 0.0468),
            imageView.widthAnchor.constraint(equalToConstant: Constants.screenWidth * 0.39),
            
            aboutLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            aboutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenWidth * 0.0468),
            aboutLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.screenWidth * 0.0468),
            
            descLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: aboutLabel.trailingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            descLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: Constants.screenWidth * 0.0468)

        ])
    }
}
