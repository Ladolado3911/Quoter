//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorker? { get set }
    
    var loadedQuotes: [ExploreQuote]? { get set }
}

class ExploreInteractor: ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorker?
    
    var loadedQuotes: [ExploreQuote]? = []
    
    let testData: [UIImage] = [UIImage(named: "innovation1")!, UIImage(named: "innovation2")!, UIImage(named: "innovation3")!]
    
    
    
    
}
