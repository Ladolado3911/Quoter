//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func requestDisplayInitialData()
    func requestDisplayNewData(currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int))
}

class ExploreInteractor: VCToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func requestDisplayNewData(currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int)) {
        let contentWorker = ContentWorker()
        contentWorker.getContent { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatNewData(currentVMs: currentVMs,
                                          capturedPage: capturedPage,
                                          edges: edges,
                                          quoteModels: quoteModels,
                                          images: images)
        }
    }
    
    func requestDisplayInitialData() {
        let contentWorker = ContentWorker()
        contentWorker.getContent { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: quoteModels, images: images)
        }
    }
}
