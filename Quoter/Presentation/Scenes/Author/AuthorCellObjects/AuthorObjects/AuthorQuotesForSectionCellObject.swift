//
//  AuthorQuotesForSectionCellObject.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/17/22.
//

import UIKit
import Lottie


class AuthorQuotesForSectionCellObject: CellProtocol {
    
    var sectionNameOfCell: String = "Other quotes"
    
    var cellIdentifier: String {
        AuthorQuotesForSectionCell.cellIdentifier
    }
    
    var rowHeight: CGFloat {
        Constants.screenHeight * 0.2 + 20
    }
    
    var innerCollectionView: UICollectionView {
        AuthorQuotesForSectionCell.collectionView
    }
    
    var innerCollectionViewDataCount: Int {
        dataForInnerCollectionView.count
    }
    
    var dataForInnerCollectionView: [Any?] = []
    
    class AuthorQuotesForSectionCell: UITableViewCell {
        
        static let cellIdentifier: String = String(describing: AuthorQuotesForSectionCellObject.AuthorQuotesForSectionCell.self)
        
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
            backgroundColor = .clear
            buildSubviews()
            buildConstraints()
        }
        
        func buildSubviews() {
            addSubview(AuthorQuotesForSectionCell.collectionView)
        }
        
        func buildConstraints() {
            NSLayoutConstraint.activate([
                AuthorQuotesForSectionCell.collectionView.topAnchor.constraint(equalTo: topAnchor),
                AuthorQuotesForSectionCell.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.screenWidth * 0.0468),
                AuthorQuotesForSectionCell.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenWidth * 0.0468),
                AuthorQuotesForSectionCell.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
    
    class ChildCell: UICollectionViewCell {
        
        static let cellIdentifier: String = String(describing: ChildCell.self)
        
        let quoteLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = DarkModeColors.lightBlack
            layer.cornerRadius = 25
            layer.applySketchShadow(color: DarkModeColors.black,
                                         alpha: 0.4,
                                         x: 1,
                                         y: 2,
                                         blur: 2,
                                         spread: 0)
            buildSubviews()
            buildConstraints()
        }
        
        private func buildSubviews() {
            addSubview(quoteLabel)
        }
        
        private func buildConstraints() {
            NSLayoutConstraint.activate([
                quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * 0.0937),
                quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bounds.width * 0.0937),
                quoteLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bounds.height * 0.111),
            ])
        }
        
        
    }
    
    func configureInnerCollectionView(target: UIViewController) {
        if let vc = target as? AuthorVC {
            AuthorQuotesForSectionCell.collectionView.dataSource = vc
            AuthorQuotesForSectionCell.collectionView.delegate = vc
            AuthorQuotesForSectionCell.collectionView.register(ChildCell.self, forCellWithReuseIdentifier: ChildCell.cellIdentifier)
        }
    }
    
    func dequeInnerCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell {
        AuthorQuotesForSectionCell.collectionView.dequeueReusableCell(withReuseIdentifier: ChildCell.cellIdentifier, for: indexPath)
    }
    
    func didSelectInnerCollectionViewCell() {
        
    }
    
    func sizeForInnerCollectionViewItemAt() -> CGSize {
        CGSize(width: rowHeight * 1.6918, height: AuthorQuotesForSectionCell.collectionView.bounds.height - 10)
    }
    
    func willDisplayInnerCollectionViewCell(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dataArr = dataForInnerCollectionView as? [String],
           let cell = cell as? ChildCell {
            let quote = dataArr[indexPath.item]
            cell.quoteLabel.text = quote
        }
    }

    func registerCell(_ tableView: UITableView) {
        tableView.register(AuthorQuotesForSectionCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func dequeCell(_ tableView: UITableView) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AuthorQuotesForSectionCell
    }

    func willDisplay(_ cell: UITableViewCell, networkWorker: CustomNetworkWorkerProtocol) {
        if let networkWorker = networkWorker as? AuthorNetworkWorker,
           let authorID = AuthorCellsManager.shared.authorID,
           let cell = cell as? AuthorQuotesForSectionCell {
            let animationSize: CGFloat = 120
            cell.createAndStartLoadingLottieAnimation(animation: .simpleLoading,
                                                      animationSpeed: 1,
                                                      frame: CGRect(x: cell.bounds.width / 2 - (animationSize / 2),
                                                                    y: cell.bounds.height / 2 - (animationSize / 2),
                                                                    width: animationSize,
                                                                    height: animationSize),
                                                      loopMode: .loop,
                                                      contentMode: .scaleAspectFit,
                                                      completion: nil)
            Task.init {
                let quotesForSectionContentResponse = try await networkWorker.getAuthorQuotesForSection(authorID: authorID)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.dataForInnerCollectionView = quotesForSectionContentResponse.quotes
                    self.sectionNameOfCell = quotesForSectionContentResponse.sectionName
                    AuthorQuotesForSectionCell.collectionView.reloadData()
                    //AuthorCellsManager.shared.dispatchGroup.leave()
                    cell.stopLoadingLottieAnimationIfExists()
                }
            }
        }
    }
}
