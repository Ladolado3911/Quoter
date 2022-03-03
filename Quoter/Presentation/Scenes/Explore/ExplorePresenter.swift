//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol InteractorToPresenterProtocol: AnyObject {
    var vc: PresenterToVCProtocol? { get set }
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?])
}

class ExplorePresenter: InteractorToPresenterProtocol {
    var vc: PresenterToVCProtocol?
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?]) {
        
        let shuffledImages = images.shuffled()
        let quoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        let indexPaths = quoteVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        vc?.displayInitialData(loadedVMs: quoteVMs, loadedImages: shuffledImages, indexPaths: indexPaths)
    }
}
