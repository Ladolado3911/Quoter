//
//  ThirdPartyButton.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

enum ThirdPartyButtonType {
    case google
    case apple
}

class ThirdPartyButtonView: UIView {

    let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = DarkModeColors.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(buttonType: ThirdPartyButtonType) {
        self.init(frame: .zero)
        switch buttonType {
        case .google:
            titleLabel.text = "Continue with Google"
            iconView.image = ProfileIcons.googleIcon
        case .apple:
            titleLabel.text = "Continue with Apple"
            iconView.image = ProfileIcons.appleIcon
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.white
        layer.cornerRadius = 20
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(iconView)
        addSubview(titleLabel)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor),
        
        ])
    }
    
    
}
