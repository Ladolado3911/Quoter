//
//  GalleryView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

class GalleryView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gallery"
        label.textColor = DarkModeColors.white
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "No quotes. Go to explore to add quotes"
        label.textColor = DarkModeColors.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alpha = 0
        collectionView.backgroundColor = .red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    func hideContent() {
        for subview in subviews {
            subview.alpha = 0
        }
    }
    
    func hideInfoLabel() {
        infoLabel.alpha = 0
    }
    
    func showInfoLabel(with text: String) {
        infoLabel.alpha = 1
        infoLabel.text = text
    }
    
    func showCollectionView() {
        collectionView.alpha = 1
    }
    
    func hideCollectionView() {
        collectionView.alpha = 0
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(collectionView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
        
        ])
    }
}
