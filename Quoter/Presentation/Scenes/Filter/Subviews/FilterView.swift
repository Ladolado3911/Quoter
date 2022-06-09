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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alignment = .center
        collectionView.verticalSpacing = 20
        collectionView.horizontalSpacing = 10
        collectionView.enableTagSelection = true
        collectionView.scrollDirection = .vertical
        collectionView.selectionLimit = 1
        collectionView.alpha = 0
        return collectionView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel", for: .normal)
        button.setTitleColor(DarkModeColors.subtitleGrey, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(bounds.height * 0.032)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(FilterIcons.arrowDown.resizedImage(targetHeight: bounds.height * 0.077), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter", for: .normal)
        button.setTitleColor(DarkModeColors.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(bounds.height * 0.032)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mainTitleLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Categories"
        mainLabel.textColor = DarkModeColors.white
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        return mainLabel
    }()
    
    let subTitleLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.text = "General"
        subLabel.textColor = DarkModeColors.subtitleGrey
        subLabel.translatesAutoresizingMaskIntoConstraints = false
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
//        addSubview(mainTitleLabel)
//        addSubview(subTitleLabel)
//        addSubview(collectionView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cancelButton.bottomAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: -5),
            cancelButton.heightAnchor.constraint(equalToConstant: bounds.height * 0.0495),
            cancelButton.widthAnchor.constraint(equalToConstant: bounds.height * 0.0495 * 2.913),
            
            arrowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowButton.topAnchor.constraint(equalTo: topAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: bounds.height * 0.09),
            arrowButton.heightAnchor.constraint(equalToConstant: bounds.height * 0.09),
            
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            filterButton.bottomAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: -5),
            filterButton.heightAnchor.constraint(equalToConstant: bounds.height * 0.0495),
            filterButton.widthAnchor.constraint(equalToConstant: bounds.height * 0.0495 * 2.913),
        
        ])
    }
}
