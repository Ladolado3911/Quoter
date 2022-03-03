//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func displayInitialData()
}

class ExploreInteractor: VCToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func displayInitialData() {
        let imageWorker = ImageWorker()
        let quoteWorker = QuoteWorker()
        
        var resultQuoteModels: [QuoteGardenQuoteModel] = []
        var resultImages: [UIImage?] = []
        
        let group = DispatchGroup()
        
        group.enter()
        imageWorker.get10LandscapeImages { result in
            switch result {
            case .success(let images):
                resultImages.append(contentsOf: images)
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        quoteWorker.get10RandomQuotes(genre: "") { result in
            switch result {
            case .success(let quoteModels):
                resultQuoteModels.append(contentsOf: quoteModels)
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: resultQuoteModels, images: resultImages)
        }
    }
}
