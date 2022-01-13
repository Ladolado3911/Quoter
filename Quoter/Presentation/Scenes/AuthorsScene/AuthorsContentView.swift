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
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    let setQuoteButton: UIButton = {
        let button = UIButton(type: .custom)
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
        addSubview(collectionView)
        addSubview(setQuoteButton)
        addSubview(titleLabel)
    }
    
    private func buildConstraints() {
        
    }
}
