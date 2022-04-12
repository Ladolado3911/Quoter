//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol InteractorToExplorePresenterProtocol: AnyObject {
    var vc: PresenterToExploreVCProtocol? { get set }
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?], imageURLs: [String?])
    
    func formatNewData(currentVMs: [QuoteGardenQuoteVM],
                       capturedPage: Int,
                       edges: (Int, Int),
                       quoteModels: [QuoteGardenQuoteModel],
                       images: [UIImage?],
                       imageURLs: [String?])
    func startAnimating()
    func setTimer()
    func formatIdeaChange()
    func addWifiButtonIfNeeded()
    func presentNetworkErrorAlert()
    func presentInitialNetworkErrorAlert()
}

class ExplorePresenter: InteractorToExplorePresenterProtocol {
    var vc: PresenterToExploreVCProtocol?

    func formatNewData(currentVMs: [QuoteGardenQuoteVM],
                       capturedPage: Int,
                       edges: (Int, Int),
                       quoteModels: [QuoteGardenQuoteModel],
                       images: [UIImage?],
                       imageURLs: [String?]) {
        
        let shuffledImages = images.shuffled()
        var newCurrentVMs = currentVMs
        let additionalQuoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        newCurrentVMs.append(contentsOf: additionalQuoteVMs)
        let indexPaths = newCurrentVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        let newIndexPaths = Array(indexPaths[(capturedPage + edges.0)...capturedPage + edges.1])
        let shuffledImageURLs = imageURLs.shuffled()
        vc?.displayNewData(loadedVMs: additionalQuoteVMs, loadedImages: shuffledImages, indexPaths: newIndexPaths, imageURLs: shuffledImageURLs)
    }
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?], imageURLs: [String?]) {
        let shuffledImages = images.shuffled()
        let quoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        let indexPaths = quoteVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        
        let shuffledImageURLs = imageURLs.shuffled()

        vc?.displayInitialData(loadedVMs: quoteVMs, loadedImages: shuffledImages, indexPaths: indexPaths, imageURLs: shuffledImageURLs)
    }
    
    func startAnimating() {
        vc?.startAnimating()
    }
    
    func setTimer() {
        vc?.setTimer()
    }
    
    func formatIdeaChange() {
        vc?.displayIdeaChange()
    }
    
    func addWifiButtonIfNeeded() {
        vc?.addWifiButton()
    }
    
    func presentNetworkErrorAlert() {
        vc?.displayNetworkErrorAlert()
    }
    
    func presentInitialNetworkErrorAlert() {
        vc?.displayInitialNetworkErrorAlert()
    }
}
