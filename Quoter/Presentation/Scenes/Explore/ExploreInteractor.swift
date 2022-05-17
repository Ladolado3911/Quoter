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
    func getInitialQuotes(genre: String)
    
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
    
    func getInitialQuotes(genre: String) {
        Task.init(priority: .high) {
            async let firstQuote = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let secondQuote = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let thirdQuote = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let four = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let five = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let six = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let seven = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let eight = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            async let nine = exploreNetworkWorker?.getUniqueRandomQuote(genre: genre)
            let quotes = try await [firstQuote, secondQuote, thirdQuote, four, five, six, seven, eight, nine].compactMap { $0 }
            DispatchQueue.main.async {
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
            let quote = loadedQuotes?[indexPath.row]
            cell.imgView.sd_setImage(with: URL(string: quote?.quoteImageURLString ?? ""),
                                     placeholderImage: nil,
                                     options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed]) { _, _, _, _ in
                cell.authorNameLabel.text = quote?.author.name
                cell.quoteContentLabel.text = quote?.content
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
