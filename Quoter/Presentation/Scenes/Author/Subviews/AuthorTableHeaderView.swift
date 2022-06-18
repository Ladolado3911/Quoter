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
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let aboutLabel: UILabel = {
        let aboutLabel = UILabel()
        aboutLabel.text = "About"
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        return aboutLabel
    }()
    
    let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.numberOfLines = 3
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
            
        ])
    }
}
