//
//  MenuHeaderView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

final class MenuHeaderView: UITableViewHeaderFooterView {
    
    let logoIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MenuIcons.logoIcon
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(logoIconView)
        NSLayoutConstraint.activate([
            logoIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoIconView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            logoIconView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0774),
            logoIconView.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0774)
        ])
    }
}
