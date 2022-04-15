//
//  MenuHeaderView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

class MenuHeaderView: UITableViewHeaderFooterView {
    
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
            logoIconView.heightAnchor.constraint(equalToConstant: 44),
            logoIconView.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
}
