//
//  AuthorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit

class AuthorView: UIView {
    
    let backButton: ArrowButton = {
        let button = ArrowButton(direction: .up, arrowIcon: FilterIcons.arrowDown)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(backButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            backButton.heightAnchor.constraint(equalToConstant: Constants.screenWidth * 0.1093),
            backButton.widthAnchor.constraint(equalToConstant: Constants.screenWidth * 0.1093)
        ])
    }
}
