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
        let layout = AnimatedCollectionViewLayout()
         layout.animator = CrossFadeAttributesAnimator()
         let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
         if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
             layout.scrollDirection = .horizontal
         }
         collectionView.backgroundColor = .clear
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.isPagingEnabled = true
         return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(collectionView)
    }
    
    private func buildConstraints() {
        
    }
}
