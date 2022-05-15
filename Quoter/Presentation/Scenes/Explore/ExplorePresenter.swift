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
            var exploreBigQuotes: [ExploreBigQuoteProtocol] = []
            for item in rawQuote.author.bigQuotes {
                let exploreBigQuote = ExploreBigQuote(content: item.content)
                exploreBigQuotes.append(exploreBigQuote)
            }
            let exploreSubCategory = ExploreSubCategory(randomImageURLString: rawQuote.subCategory.randomImageURLString)
            let exploreAuthor = ExploreAuthor(name: rawQuote.author.name, authorImageURLString: rawQuote.author.authorImageURLString, bigQuotes: exploreBigQuotes)
            let exploreQuote = ExploreQuote(content: rawQuote.content, author: exploreAuthor, subCategory: exploreSubCategory)
            result.append(exploreQuote)
        }
        vc?.displayInitialQuotes(exploreQuotes: result)
    }
}
