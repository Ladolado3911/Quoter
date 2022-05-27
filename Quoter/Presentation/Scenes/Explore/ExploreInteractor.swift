//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit
import SDWebImage

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var loadedQuotes: [ExploreQuoteProtocol]? { get set }
    
    
    //MARK: Explore Scene Network Methods
    //func getFirstQuote(genre: String)
    func getInitialQuotes(genre: String, limit: Int)
    
    //MARK: collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol]? = []
    
    func getInitialQuotes(genre: String, limit: Int) {
        Task.init(priority: .high) {
            let quotes = try await self.exploreNetworkWorker?.getQuotes(genre: genre, limit: limit)
            await MainActor.run {
                self.presenter?.formatInitialQuotes(rawQuotes: quotes)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadedQuotes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ExploreCell {
            cell.startAnimating()
            cell.buildSubviews()
            cell.buildConstraints()
            let quote = loadedQuotes?[indexPath.row]
            cell.imgView.sd_setImage(with: URL(string: quote?.quoteImageURLString ?? ""),
                                     placeholderImage: nil,
                                     options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed]) { _, _, _, _ in
                cell.authorNameLabel.text = quote?.author.name
                cell.quoteContentLabel.text = quote?.content
                cell.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UIScreen.main.bounds.size
    }
}
