//
//  ContentView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit
import Combine

class AuthorsContentView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Quoter"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        return collectionView
    }()
    
    var setQuoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("See Quotes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        button.layer.cornerRadius = 10

        return button
    }()
    
    let blackBackgroundView: UIView = {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        blackView.layer.cornerRadius = 20
        return blackView
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
        addSubview(blackBackgroundView)
    }
    
    private func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.0246)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(setQuoteButton.snp.top).inset(-20)
            make.top.equalTo(titleLabel.snp.bottom).inset(-PublicConstants.screenHeight * 0.03)
        }
        setQuoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(blackBackgroundView.snp.top).inset(-20)
            make.centerX.equalTo(self)
            make.width.equalTo(PublicConstants.screenWidth * 0.625)
        }
        blackBackgroundView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(PublicConstants.screenHeight * 0.1338)
        }
    }
}
