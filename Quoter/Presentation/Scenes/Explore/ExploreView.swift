//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//

import UIKit
import AnimatedCollectionViewLayout

enum Direction {
    case left
    case right
    case up
    case down
}

class ArrowButton: UIButton {
    
    var direction: Direction = .left
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience override init(frame: CGRect, d) {
        <#code#>
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

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
