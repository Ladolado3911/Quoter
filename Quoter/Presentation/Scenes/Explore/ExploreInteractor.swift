//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToExploreInteractorProtocol: AnyObject {
    var presenter: InteractorToExplorePresenterProtocol? { get set }
    
    func requestDisplayInitialData(genres: [String])
    func requestDisplayNewData(genres: [String], currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int))
    func requestNewData(edges: (Int, Int), offsetOfPage: Int)
}

class ExploreInteractor: VCToExploreInteractorProtocol {
    var presenter: InteractorToExplorePresenterProtocol?

    func requestDisplayNewData(genres: [String], currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int)) {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: genres) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatNewData(currentVMs: currentVMs,
                                          capturedPage: capturedPage,
                                          edges: edges,
                                          quoteModels: quoteModels,
                                          images: images)
        }
    }
    
    func requestDisplayInitialData(genres: [String]) {
        let contentWorker = ExploreContentWorker()
        contentWorker.getContent(genres: genres) { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: quoteModels, images: images)
        }
    }
    
    func requestNewData(edges: (Int, Int), offsetOfPage: Int) {
        presenter?.transfer(edges: edges, offsetOfPage: offsetOfPage)
    }
}
