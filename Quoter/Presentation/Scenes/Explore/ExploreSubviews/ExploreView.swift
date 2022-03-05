//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit
import AnimatedCollectionViewLayout

class ExploreView: LottieView {
    
    lazy var collectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "cell")
//
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(collectionView)
    }
    
    func startAnimating() {
        let size = bounds.width / 3.5
        let x = bounds.width / 2 - (size / 2)
        let y = bounds.height / 2 - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        createAndStartLottieAnimation(animation: .circleLoading,
                                      animationSpeed: 1,
                                      frame: frame,
                                      loopMode: .loop,
                                      contentMode: .scaleAspectFit)
    }
    
    func stopAnimating() {
        //darkView.isHidden = false
        stopLottieAnimation()
    }
    
}
