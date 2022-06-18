//
//  OtherAuthorsForSectionCellObject.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit


class OtherAuthorsForSectionCellObject: CellProtocol {
    
    var sectionNameOfCell: String = "Other authors"
    
    var cellIdentifier: String {
        OtherAuthorsForSectionCell.cellIdentifier
    }
    
    var rowHeight: CGFloat {
        Constants.screenHeight * 0.2306
    }
    
    var innerCollectionView: UICollectionView {
        OtherAuthorsForSectionCell.collectionView
    }
    
    var innerCollectionViewDataCount: Int {
        5
    }
    
    class OtherAuthorsForSectionCell: UITableViewCell {
        
        static let cellIdentifier: String = String(describing: OtherAuthorsForSectionCellObject.OtherAuthorsForSectionCell.self)
        
        static let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectView.backgroundColor = .clear
            collectView.translatesAutoresizingMaskIntoConstraints = false
            return collectView
        }()
        
        override func layoutSubviews() {
            super.layoutSubviews()
            buildSubviews()
            buildConstraints()
        }
        
        func buildSubviews() {
            addSubview(OtherAuthorsForSectionCell.collectionView)
        }
        
        func buildConstraints() {
            NSLayoutConstraint.activate([
                OtherAuthorsForSectionCell.collectionView.topAnchor.constraint(equalTo: topAnchor),
                OtherAuthorsForSectionCell.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                OtherAuthorsForSectionCell.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                OtherAuthorsForSectionCell.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
    
    class ChildCell: UICollectionViewCell {
        
        static let cellIdentifier: String = String(describing: ChildCell.self)
        
        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = .brown
        }
        
        
    }
    
    func configureInnerCollectionView(target: UIViewController) {
        if let vc = target as? AuthorVC {
            OtherAuthorsForSectionCell.collectionView.dataSource = vc
            OtherAuthorsForSectionCell.collectionView.delegate = vc
            OtherAuthorsForSectionCell.collectionView.register(ChildCell.self, forCellWithReuseIdentifier: ChildCell.cellIdentifier)
        }
    }
    
    func dequeInnerCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell {
        OtherAuthorsForSectionCell.collectionView.dequeueReusableCell(withReuseIdentifier: ChildCell.cellIdentifier, for: indexPath)
    }
    
    func didSelectInnerCollectionViewCell() {
        
    }
    
    func sizeForItemAt() -> CGSize {
        CGSize(width: 100, height: OtherAuthorsForSectionCell.collectionView.bounds.height)
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(OtherAuthorsForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OtherAuthorsForSectionCell
    }
    
    func willDisplay(_ cell: UITableViewCell) {
        if let cell = cell as? OtherAuthorsForSectionCell {

        }
    }
}

