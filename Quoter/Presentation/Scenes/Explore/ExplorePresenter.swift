//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExplorePresenterProtocol {
    var vc: ExploreVCProtocol? { get set }
    
    func formatInitialQuotes(rawQuotes: [QuoteModel?]?)
}

class ExplorePresenter: ExplorePresenterProtocol {
    var vc: ExploreVCProtocol?
    
    func formatInitialQuotes(rawQuotes: [QuoteModel?]?) {
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
        vc?.displayInitialQuotes(exploreQuotes: result)
    }
}
