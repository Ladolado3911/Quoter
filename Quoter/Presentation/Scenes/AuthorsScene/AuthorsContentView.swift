//
//  ContentView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit

class AuthorsContentView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Quoter"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    let setQuoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("See Quotes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        button.layer.cornerRadius = 10

        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 20
        backgroundColor = .white
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(setQuoteButton)
    }
    
    private func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.0246)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(setQuoteButton.snp.top).inset(-PublicConstants.screenHeight * 0.0387)
            make.top.equalTo(titleLabel.snp.bottom).inset(-PublicConstants.screenHeight * 0.0246)
        }
        setQuoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(PublicConstants.screenHeight * 0.02288)
            make.centerX.equalTo(self)
            make.width.equalTo(PublicConstants.screenWidth * 0.625)
        }
    }
}
