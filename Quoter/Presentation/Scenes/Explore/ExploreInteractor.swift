//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit
import SDWebImage

enum ExploreDirection {
    case left
    case right
}

enum Genre: String {
    case rich
    case writers
    case politicians
    case artists
    case sportsmen
    case actors
    case scientists
    case ancients
    case general
}

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var loadedQuotes: [ExploreQuoteProtocol?]? { get set }
    var currentPage: Int { get set }
    var currentGenre: Genre { get set }
    
    //MARK: Collection View methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    //func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
    
    //MARK: Scroll View methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scroll(direction: ExploreDirection)
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol?]? = Array(repeating: nil, count: 5)
    var currentPage: Int = 0
    var currentGenre: Genre = .general
    
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
            Task.init(priority: .high) {
                var quote: ExploreQuoteProtocol
                if let arr = loadedQuotes,
                   let unwrapped = arr[indexPath.item] {
                    quote = unwrapped
                }
                else {
                    let quoteModel = try await exploreNetworkWorker?.getSmallQuote(genre: currentGenre)
                    let exploreAuthor = ExploreAuthor(slug: quoteModel!.author.slug,
                                                      name: quoteModel!.author.name,
                                                      authorImageURLString: quoteModel!.author.authorImageURLString)
                    let exploreQuote = ExploreQuote(quoteImageURLString: quoteModel!.quoteImageURLString,
                                                    content: quoteModel!.content,
                                                    author: exploreAuthor)
                    quote = exploreQuote
                }
                await MainActor.run { [quote] in
                    loadedQuotes![indexPath.item] = quote
                    cell.authorNameLabel.text = quote.author.name
                    cell.quoteContentLabel.text = quote.content
                    let fontSize = cell.getFontSizeForQuote(stringCount: CGFloat(quote.content.count))
                    cell.quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: fontSize)
                    cell.imgView.sd_setImage(with: URL(string: quote.quoteImageURLString),
                                             placeholderImage: nil,
                                             options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed]) { _, _, _, _ in
                        cell.stopAnimating()
                    }
                }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        loadedQuotes?.append(nil)
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.addCellWhenSwiping(indexPaths: indexPaths)
    }
    
    func scroll(direction: ExploreDirection) {
        var contentOffsetX: CGFloat? = nil
        switch direction {
        case .left:
            if currentPage - 1 < 0 {
                return
            }
            currentPage -= 1
            contentOffsetX = -Constants.screenWidth
        case .right:
            currentPage += 1
            contentOffsetX = Constants.screenWidth
        }
        loadedQuotes?.append(nil)
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.scroll(direction: direction, contentOffsetX: contentOffsetX!, indexPaths: indexPaths)
    }
}
