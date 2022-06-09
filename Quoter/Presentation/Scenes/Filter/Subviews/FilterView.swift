//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/8/22.
//

import UIKit
import TTGTags

class FilterView: ModalViewWithTopBorder {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var mainTitleLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Categories"
        mainLabel.textColor = DarkModeColors.white
        mainLabel.font = mainLabel.font.withSize(bounds.height * 0.035)
        mainLabel.textAlignment = .center
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        return mainLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.text = "General"
        subLabel.textColor = DarkModeColors.subtitleGrey
        subLabel.font = subLabel.font.withSize(bounds.height * 0.025)
        subLabel.textAlignment = .center
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
        addSubview(mainTitleLabel)
        addSubview(subTitleLabel)
        addSubview(collectionView)
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
        
            mainTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: arrowButton.bottomAnchor),
            mainTitleLabel.heightAnchor.constraint(equalToConstant: bounds.height * 0.0841),
            mainTitleLabel.widthAnchor.constraint(equalToConstant: bounds.height * 0.0841 * 4.428),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: mainTitleLabel.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor),
            subTitleLabel.heightAnchor.constraint(equalToConstant: bounds.height * 0.0841 * 0.3),
            subTitleLabel.widthAnchor.constraint(equalToConstant: bounds.height * 0.0841 * 4.428),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            collectionView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
