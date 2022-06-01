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

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var loadedQuotes: [ExploreQuoteProtocol]? { get set }
    var isLoadQuotesFunctionRunning: Bool { get set }
    var isCurrentPageInCorrectZone: Bool { get set }
    var currentPage: Int { get set }
    var correctZone: [Int] { get set }
    
    //MARK: Explore Scene Network Methods
    func loadQuotes(genre: String, limit: Int, priority: TaskPriority, isInitial: Bool, size: QuoteSize)
    func loadQuotesNegotiated(genre: String, priority: TaskPriority, isInitial: Bool, size: QuoteSize)
    
    //MARK: Collection View methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    //MARK: Scroll View methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scroll(direction: ExploreDirection)
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol]? = []
    var isLoadQuotesFunctionRunning = false
    var isCurrentPageInCorrectZone = false
    var currentPage: Int = 0
    var correctZone: [Int] = []
    
    func loadQuotes(genre: String, limit: Int, priority: TaskPriority, isInitial: Bool, size: QuoteSize) {
        Task.init(priority: priority) {
            let quotes = try await self.exploreNetworkWorker?.getQuotes(genre: genre, limit: limit, size: size)
            await MainActor.run {
                isLoadQuotesFunctionRunning = false
                self.presenter?.formatQuotes(rawQuotes: quotes, isInitial: isInitial)
            }
        }
    }
    
    func loadQuotesNegotiated(genre: String, priority: TaskPriority, isInitial: Bool, size: QuoteSize) {
        Task.init(priority: priority) {
            let quotes = try await self.exploreNetworkWorker?.getQuotesNegotiated(genre: genre, size: size)
            await MainActor.run {
                isLoadQuotesFunctionRunning = false
                self.presenter?.formatQuotes(rawQuotes: quotes, isInitial: isInitial)
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
            let quote = loadedQuotes?[indexPath.item]
            cell.authorNameLabel.text = quote?.author.name
            cell.quoteContentLabel.text = quote?.content
            let fontSize = cell.getFontSizeForQuote(stringCount: CGFloat(quote!.content.count))
            cell.quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: fontSize)
            cell.imgView.sd_setImage(with: URL(string: quote?.quoteImageURLString ?? ""),
                                     placeholderImage: nil,
                                     options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed]) { _, _, _, _ in
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print(currentPage)
        if correctZone.contains(currentPage) {
            isCurrentPageInCorrectZone = true
        }
        else {
            isCurrentPageInCorrectZone = false
        }
        if isCurrentPageInCorrectZone && !isLoadQuotesFunctionRunning  {
            isLoadQuotesFunctionRunning = true
            let indexes = loadedQuotes?.enumerated().map { $0.offset }
            correctZone = indexes!.compactMap { $0 }
            loadQuotesNegotiated(genre: "rich", priority: .medium, isInitial: false, size: .small)
            //loadQuotes(genre: "rich", limit: 5, priority: .medium, isInitial: false, size: .small)
        }
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
        if correctZone.contains(currentPage) {
            isCurrentPageInCorrectZone = true
        }
        else {
            isCurrentPageInCorrectZone = false
        }
        if isCurrentPageInCorrectZone && !isLoadQuotesFunctionRunning  {
            isLoadQuotesFunctionRunning = true
            let indexes = loadedQuotes?.enumerated().map { $0.offset }
            correctZone = indexes!.compactMap { $0 }
            loadQuotesNegotiated(genre: "rich", priority: .medium, isInitial: false, size: .small)
            //loadQuotes(genre: "rich", limit: 5, priority: .medium, isInitial: false, size: .small)
        }
        presenter?.scroll(direction: direction, contentOffsetX: contentOffsetX!)
    }
}
