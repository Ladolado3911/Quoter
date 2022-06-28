//
//  ProfileView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

class ProfileView: UIView {
    
    let vstack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.distribution = .equalSpacing
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let userNameLabelHStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .equalCentering
        hstack.alignment = .center
        hstack.isLayoutMarginsRelativeArrangement = true
        hstack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Profile"
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textColor = DarkModeColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signoutButtonHStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .equalCentering
        hstack.alignment = .center
        hstack.isLayoutMarginsRelativeArrangement = true
        hstack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "MarkZuckerberg@gmail.com"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = DarkModeColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let signoutButton: CallToActionButton = {
        let signoutButton = CallToActionButton()
        signoutButton.callToActionButtonType = .signOut
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        return signoutButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        userNameLabelHStack.addArrangedSubview(userNameLabel)
        signoutButtonHStack.addArrangedSubview(signoutButton)
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(userNameLabelHStack)
        vstack.addArrangedSubview(menuCollectionView)
        vstack.addArrangedSubview(signoutButtonHStack)
        addSubview(vstack)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.screenHeight * 0.1),
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vstack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.2),
            
            menuCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.352),
            userNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])
    }
    
}
