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
    func formatNewData(currentVMs: [QuoteGardenQuoteVM], capturedPage: Int, edges: (Int, Int), quoteModels: [QuoteGardenQuoteModel], images: [UIImage?])
}

class ExplorePresenter: InteractorToPresenterProtocol {
    var vc: PresenterToVCProtocol?
    
    func formatNewData(currentVMs: [QuoteGardenQuoteVM],
                       capturedPage: Int,
                       edges: (Int, Int),
                       quoteModels: [QuoteGardenQuoteModel],
                       images: [UIImage?]) {
        var newCurrentVMs = currentVMs
        let shuffledImages = images.shuffled()
        let additionalQuoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        newCurrentVMs.append(contentsOf: additionalQuoteVMs)
        let indexPaths = newCurrentVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        let newIndexPaths = Array(indexPaths[(capturedPage + edges.0)...capturedPage + edges.1])
        vc?.displayNewData(loadedVMs: currentVMs, loadedImages: shuffledImages, indexPaths: newIndexPaths)
    }
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?]) {
        let shuffledImages = images.shuffled()
        let quoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        let indexPaths = quoteVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        vc?.displayInitialData(loadedVMs: quoteVMs, loadedImages: shuffledImages, indexPaths: indexPaths)
    }
}
