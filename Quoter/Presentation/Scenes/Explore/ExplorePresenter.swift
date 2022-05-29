//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExplorePresenterProtocol {
    var vc: ExploreVCProtocol? { get set }
    
    func formatQuotes(rawQuotes: [QuoteModel?]?, isInitial: Bool)
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat)
}

class ExplorePresenter: ExplorePresenterProtocol {
    var vc: ExploreVCProtocol?
    
    func formatQuotes(rawQuotes: [QuoteModel?]?, isInitial: Bool) {
        var result: [ExploreQuoteProtocol] = []
        guard let rawQuotes = rawQuotes else {
            return
        }
        let unwrappedQuotes = rawQuotes.compactMap { $0 }
        for quote in unwrappedQuotes {
            let exploreAuthor = ExploreAuthor(slug: quote.author.slug, name: quote.author.name, authorImageURLString: quote.author.authorImageURLString)
            let exploreQuote = ExploreQuote(quoteImageURLString: quote.quoteImageURLString, content: quote.content, author: exploreAuthor)
            result.append(exploreQuote)
        }
        if isInitial {
            vc?.displayInitialQuotes(exploreQuotes: result)
        }
        else {
            vc?.displayNextQuotes(exploreQuotes: result)
        }
    }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat) {
        vc?.scroll(direction: direction, contentOffsetX: contentOffsetX)
    }
}
