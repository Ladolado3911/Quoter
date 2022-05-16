//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExplorePresenterProtocol {
    var vc: ExploreVCProtocol? { get set }
    
    func formatInitialQuotes(rawQuotes: [QuoteModel])
}

class ExplorePresenter: ExplorePresenterProtocol {
    var vc: ExploreVCProtocol?
    
    func formatInitialQuotes(rawQuotes: [QuoteModel]) {
        var result: [ExploreQuoteProtocol] = []
        for rawQuote in rawQuotes {
            let exploreAuthor = ExploreAuthor(slug: rawQuote.author.slug, name: rawQuote.author.name, authorImageURLString: rawQuote.author.authorImageURLString)
            let exploreQuote = ExploreQuote(quoteImageURLString: rawQuote.quoteImageURLString, content: rawQuote.content, author: exploreAuthor)
            result.append(exploreQuote)
        }
        vc?.displayInitialQuotes(exploreQuotes: result)
    }
}
