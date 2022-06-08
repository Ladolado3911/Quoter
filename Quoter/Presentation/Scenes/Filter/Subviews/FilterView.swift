//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/8/22.
//

import UIKit
import TTGTags

class FilterView: ModalViewWithTopBorder {
    
    lazy var collectionView: TTGTextTagCollectionView = {
        let collectionView = TTGTextTagCollectionView()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alignment = .center
        collectionView.verticalSpacing = 20
        collectionView.horizontalSpacing = 10
        collectionView.enableTagSelection = true
        collectionView.scrollDirection = .vertical
        collectionView.selectionLimit = 1
        collectionView.alpha = 0
        return collectionView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let arrowButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let mainTitleLabel: UILabel = {
        let mainLabel = UILabel()
        return mainLabel
    }()
    
    let subTitleLabel: UILabel = {
        let subLabel = UILabel()
        return subLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(cancelButton)
        addSubview(arrowButton)
        addSubview(filterButton)
        addSubview(mainTitleLabel)
        addSubview(subTitleLabel)
        addSubview(collectionView)
    }
    
    private func buildConstraints() {
        
    }
}
