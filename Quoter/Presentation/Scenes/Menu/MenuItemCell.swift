//
//  MenuItemView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuItemView: UIView {
    
    let titleLabel: UILabel = {
        let field = UILabel()
        field.textColor = DarkModeColors.white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MenuIcons.exploreIcon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var vc: BaseVC?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, with item: MenuItem) {
        self.init(frame: frame)
        titleLabel.text = item.title
        iconImageView.image = item.icon
        vc = item.viewController
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(iconImageView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        ])
    }

}
