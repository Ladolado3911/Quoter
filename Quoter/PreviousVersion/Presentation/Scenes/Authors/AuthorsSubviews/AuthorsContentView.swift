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
    
    lazy var warningLabel: UILabel = {
        let width: CGFloat = PublicConstants.screenWidth * 0.8
        let height: CGFloat = 100
        let x = PublicConstants.screenWidth / 2 - (width / 2)
        let y: CGFloat = ((PublicConstants.screenHeight * 0.23) / 2) - (height / 2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let infoLabel = UILabel(frame: frame)
        infoLabel.text = "No favorite authors. Go to explore"
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 2
        infoLabel.textColor = .gray
        infoLabel.backgroundColor = .white
        infoLabel.font = UIFont(name: "Arial", size: 20)
        return infoLabel
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var setQuoteButton: SetQuoteButton = {
        let button = SetQuoteButton(type: .custom)
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
        collectionView.addSubview(warningLabel)
        addSubview(setQuoteButton)
        addSubview(blackBackgroundView)
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
    }
}

class SetQuoteButton: UIButton {
    
    var isFirstLoad: Bool = true
    
    var isButtonEnabled: Bool = false {
        didSet {
            if isButtonEnabled != oldValue {
                if isButtonEnabled {
                    enableButton()
                }
                else {
                    disableButton()
                }
                //layoutSubviews()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitle("See Quotes", for: .normal)
        titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        layer.cornerRadius = 10
        
        if isFirstLoad {
            disableButton()
            isFirstLoad = false
        }
    }
    
    private func enableButton() {
        backgroundColor = .black
        setTitleColor(.white, for: .normal)
        isUserInteractionEnabled = true
    }
    
    private func disableButton() {
        backgroundColor = .gray
        setTitleColor(.black, for: .normal)
        isUserInteractionEnabled = false
    }

}
