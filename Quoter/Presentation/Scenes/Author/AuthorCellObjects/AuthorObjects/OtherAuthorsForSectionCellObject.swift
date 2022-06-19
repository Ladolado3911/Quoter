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
            collectView.showsHorizontalScrollIndicator = false
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
                OtherAuthorsForSectionCell.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.screenWidth * 0.0468),
                OtherAuthorsForSectionCell.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenWidth * 0.0468),
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
    
    func sizeForInnerCollectionViewItemAt() -> CGSize {
        CGSize(width: 100, height: OtherAuthorsForSectionCell.collectionView.bounds.height)
    }
    
    func willDisplayInnerCollectionViewCell(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(OtherAuthorsForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OtherAuthorsForSectionCell
    }
    
    func willDisplay(_ cell: UITableViewCell, networkWorker: CustomNetworkWorkerProtocol) {
        if let cell = cell as? OtherAuthorsForSectionCell {

        }
    }
}

