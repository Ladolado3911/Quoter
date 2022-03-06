//
//  QoaPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol? { get set }
    
   // func format(state: QuotesOfAuthorVCState, image: UIImage?)
    func formatTest1(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool)
    func formatTest2(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore])
}

class QoaPresenter: InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol?
    
//    func format(state: QuotesOfAuthorVCState, image: UIImage?) {
//        switch state {
//        case .network:
//            vc?.displayInitialNetworkData(image: image)
//        case .coreData:
//            let imageData = image?.pngData() ?? nil
//            vc?.displayInitialCoreData(imageData: imageData)
//        }
//    }
    
    func formatTest1(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool) {
        let quoteContent = array[currentIndex].content
        vc?.displayTest1(name: name, contentMode: contentMode, exportImage: exportImage, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
    
    func formatTest2(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore]) {
        let quotesArr = author.quotes
        let quoteContent = quotesArr[currentIndex].content ?? "No Quote"
        vc?.displayTest2(author: author, contentMode: contentMode, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
}
