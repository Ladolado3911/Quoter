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
        label.text = "Favorites"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 23)
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let x = collectionView.bounds.width / 2 - (width / 2)
        let y = bounds.height / 2 - (height / 2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        let infoLabel = UILabel(frame: frame)
        infoLabel.text = "No authors here. Go to explore"
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        return infoLabel
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
        addSubview(infoLabel)
    }
    
    private func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.0246)
            make.bottom.equalTo(collectionView.snp.top)
            //make.height.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(setQuoteButton.snp.top).inset(-PublicConstants.screenHeight * 0.02)
           // make.top.equalTo(titleLabel.snp.bottom)//.inset(-PublicConstants.screenHeight * 0.03)
            //make.height.equalTo(PublicConstants.screenHeight * 0.1919)
        }
        setQuoteButton.snp.makeConstraints { make in
            make.bottom.equalTo(blackBackgroundView.snp.top).inset(-PublicConstants.screenHeight * 0.03521126)
            make.centerX.equalTo(self)
            make.width.equalTo(PublicConstants.screenWidth * 0.625)
        }
        blackBackgroundView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(PublicConstants.screenHeight * 0.1338)
        }
//        infoLabel.snp.makeConstraints { make in
//            make.center.equalTo(collectionView.snp.center)
//            make.left.right.top.bottom.equalTo(collectionView)
//        }
    }
}
