//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/16/22.
//

import UIKit

final class AuthorTableHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 25
        imgView.layer.masksToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let aboutLabel: UILabel = {
        let aboutLabel = UILabel()
        //aboutLabel.text = "About"
        aboutLabel.textAlignment = .center
        aboutLabel.textColor = DarkModeColors.white
        aboutLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        return aboutLabel
    }()
    
    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 5
        descLabel.textColor = DarkModeColors.white
        descLabel.textAlignment = .center
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
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.screenWidth * 0.39),
            
            //aboutLabel.
            aboutLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            //aboutLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -5),
            aboutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenWidth * 0.0468),
            aboutLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.screenWidth * 0.0468),
            aboutLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.2),
            
            descLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: aboutLabel.trailingAnchor),
            descLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 10),
            //descLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            //descLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            //descLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.6),

        ])
    }
}
