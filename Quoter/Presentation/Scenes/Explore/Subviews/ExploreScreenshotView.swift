//
//  ExploreScreenshotView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/4/22.
//

import UIKit

class ExploreScreenshotView: UIView {
    
    var exploreCollectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(exploreCollectionView: UICollectionView, frame: CGRect) {
        self.init(frame: frame)
        self.exploreCollectionView = exploreCollectionView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
    }
    
    private func buildSubviews() {
        if let exploreCollectionView = exploreCollectionView {
            addSubview(exploreCollectionView)
        }
    }
}
