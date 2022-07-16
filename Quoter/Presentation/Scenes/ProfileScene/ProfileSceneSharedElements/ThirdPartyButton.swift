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
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let hStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.spacing = 10
        hstack.distribution = .fillProportionally
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
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
            iconView.image = ProfileIcons.googleIcon?.resizedImage(targetHeight: Constants.screenHeight * 0.0757)
        case .apple:
            titleLabel.text = "Continue with Apple"
            iconView.image = ProfileIcons.appleIcon?.resizedImage(targetHeight: Constants.screenHeight * 0.0757)
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
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        addSubview(hStack)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
//            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * 0.13),
//            iconView.topAnchor.constraint(equalTo: topAnchor),
//            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            iconView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.screenWidth * 0.14),
//
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bounds.width * 0.05),
//            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor),
//
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
        ])
    }
    
    
}
