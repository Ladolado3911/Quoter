//
//  AuthorQuotesForSectionCellObject.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit


class AuthorQuotesForSectionCellObject: CellProtocol {
    
    var sectionNameOfCell: String = "Other quotes"
    
    var cellIdentifier: String {
        AuthorQuotesForSectionCell.cellIdentifier
    }
    
    var rowHeight: CGFloat {
        Constants.screenHeight * 0.27992
    }
    
    var innerCollectionView: UICollectionView {
        AuthorQuotesForSectionCell.collectionView
    }
    
    class AuthorQuotesForSectionCell: UITableViewCell {
        
        static let cellIdentifier: String = String(describing: AuthorQuotesForSectionCellObject.AuthorQuotesForSectionCell.self)
        
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
            backgroundColor = .red
            buildSubviews()
            buildConstraints()
        }
        
        func buildSubviews() {
            addSubview(AuthorQuotesForSectionCell.collectionView)
        }
        
        func buildConstraints() {
            NSLayoutConstraint.activate([
                AuthorQuotesForSectionCell.collectionView.topAnchor.constraint(equalTo: topAnchor),
                AuthorQuotesForSectionCell.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                AuthorQuotesForSectionCell.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                AuthorQuotesForSectionCell.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        if let vc = target as? ExploreVC {
            AuthorQuotesForSectionCell.collectionView.dataSource = vc
            AuthorQuotesForSectionCell.collectionView.delegate = vc
            AuthorQuotesForSectionCell.collectionView.register(ChildCell.self, forCellWithReuseIdentifier: ChildCell.cellIdentifier)
        }
    }

    func registerCell(_ tableView: UITableView) {
        tableView.register(AuthorQuotesForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AuthorQuotesForSectionCell
    }

    func willDisplay(_ cell: UITableViewCell) {
        if let cell = cell as? AuthorQuotesForSectionCell {
            
        }
    }
}
