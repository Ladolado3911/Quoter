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
    
    func getInitialQuotes(genre: String) async throws
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol]? = []
    
    let testData: [UIImage] = [UIImage(named: "innovation1")!, UIImage(named: "innovation2")!, UIImage(named: "innovation3")!]
    
    func getInitialQuotes(genre: String) async throws {
        
        async let firstQuote = exploreNetworkWorker?.getRandomQuote(genre: "age")
        async let secondQuote = exploreNetworkWorker?.getRandomQuote(genre: "age")
        async let thirdQuote = exploreNetworkWorker?.getRandomQuote(genre: "age")
        
        let quotes = try await [firstQuote, secondQuote, thirdQuote].compactMap { $0 }
        presenter?.formatInitialQuotes(rawQuotes: quotes)
    }
    
    
}
