//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var loadedQuotes: [ExploreQuoteProtocol]? { get set }
    
    func getInitialQuotes(genre: String)
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol]? = []

    func getInitialQuotes(genre: String) {
        Task.init {
            async let firstQuote = exploreNetworkWorker?.getRandomQuote(genre: genre)
            async let secondQuote = exploreNetworkWorker?.getRandomQuote(genre: genre)
            async let thirdQuote = exploreNetworkWorker?.getRandomQuote(genre: genre)
            
            let quotes = try await [firstQuote, secondQuote, thirdQuote].compactMap { $0 }
            DispatchQueue.main.async {
                self.presenter?.formatInitialQuotes(rawQuotes: quotes)
            }
        }
        
    }
    
    
}
