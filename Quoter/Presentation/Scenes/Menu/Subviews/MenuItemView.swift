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
        field.textColor = DarkModeColors.grey
        field.font = UIFont(name: "Arial", size: 14)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MenuIcons.exploreIcon
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var vc: UIViewController?
    var isSelected: Bool = false
    
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
        isSelected = item.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
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
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.04),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.04),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        ])
    }
    
    private func configView() {
        if isSelected {
            titleLabel.textColor = DarkModeColors.white
        }
        else {
            titleLabel.textColor = DarkModeColors.grey
        }
    }

}
