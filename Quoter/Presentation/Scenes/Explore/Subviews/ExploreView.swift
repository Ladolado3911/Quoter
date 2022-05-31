//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//

import UIKit
import AnimatedCollectionViewLayout

class ExploreView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = ExploreLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isPagingEnabled = true
        collectionView.isPrefetchingEnabled = true
        return collectionView
    }()
    
    let leftArrowButton: ArrowButton = {
        let leftButton = ArrowButton(direction: .left)
        return leftButton
    }()
    
    let rightArrowButton: ArrowButton = {
        let rightButton = ArrowButton(direction: .right)
        return rightButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(collectionView)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        bringSubviewToFront(leftArrowButton)
        bringSubviewToFront(rightArrowButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            leftArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftArrowButton.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.11619),
            leftArrowButton.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.11619),
            leftArrowButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.screenHeight * 0.60563),
            
            rightArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightArrowButton.widthAnchor.constraint(equalTo: leftArrowButton.widthAnchor),
            rightArrowButton.heightAnchor.constraint(equalTo: leftArrowButton.heightAnchor),
            rightArrowButton.centerYAnchor.constraint(equalTo: leftArrowButton.centerYAnchor),
        
        ])
    }
    
    func startAnimating() {
        createAndStartLoadingLottieAnimation(animation: .wakeup,
                                             animationSpeed: 1,
                                             frame: CGRect(x: bounds.width / 2 - 150,
                                                           y: bounds.height / 2 - 150,
                                                           width: 300,
                                                           height: 300),
                                             loopMode: .loop,
                                             contentMode: .scaleAspectFill,
                                             completion: nil)
    }
    
    func stopAnimating() {
        stopLoadingLottieAnimationIfExists()
    }
}
