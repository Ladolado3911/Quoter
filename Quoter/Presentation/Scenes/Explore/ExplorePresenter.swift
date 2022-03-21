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
    func formatOldData()
    func startAnimating()
    func setTimer()
    func formatIdeaChange()
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
        let loadedImageDatas = shuffledImages.map { $0?.pngData() }
        
        vc?.displayNewData(loadedVMs: additionalQuoteVMs, loadedImages: shuffledImages, indexPaths: newIndexPaths, loadedImageDatas: loadedImageDatas, imageURLs: shuffledImageURLs)
    }
    
    func formatData(quoteModels: [QuoteGardenQuoteModel], images: [UIImage?], imageURLs: [String?]) {
        let shuffledImages = images.shuffled()
        let quoteVMs = quoteModels.map { QuoteGardenQuoteVM(rootModel: $0) }
        let indexPaths = quoteVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        
        let shuffledImageURLs = imageURLs.shuffled()
        let loadedImageDatas = shuffledImages.map { $0?.pngData() }
        
        vc?.displayInitialData(loadedVMs: quoteVMs, loadedImages: shuffledImages, indexPaths: indexPaths, loadedImageDatas: loadedImageDatas, imageURLs: shuffledImageURLs)
    }
    
    func formatOldData() {
        vc?.displayOldData()
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
}
