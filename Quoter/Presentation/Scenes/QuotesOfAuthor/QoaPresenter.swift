//
//  QoaPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol? { get set }
    
    func formatNetworkInitialData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool)
    func formatCoreInitialData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore])
    func formatNetworkUpdatedData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool), isIdeaButtonEnabled: Bool, quoteContent: String)
    func formatCoreUpdatedData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool), quotesArr: [QuoteCore], currentQuoteIndex: Int)
    func formatIdeaChange()
}

class QoaPresenter: InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol?
    
    func formatNetworkInitialData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool) {
        let quoteContent = array[currentIndex].content
        vc?.displayInitialNetworkData(name: name, contentMode: contentMode, exportImage: exportImage, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
    
    func formatCoreInitialData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore]) {
        let quotesArr = author.quotes
        let quoteContent = quotesArr[currentIndex].content ?? "No Quote"
        vc?.displayInitialCoreData(author: author, contentMode: contentMode, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
    
    func formatNetworkUpdatedData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool), isIdeaButtonEnabled: Bool, quoteContent: String) {
        let resultContent = (content.isNextButtonEnabled, content.isPrevButtonEnabled, isIdeaButtonEnabled, quoteContent)
        vc?.displayUpdatedNetworkData(content: resultContent)
    }
    
    func formatCoreUpdatedData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool), quotesArr: [QuoteCore], currentQuoteIndex: Int) {
        let quoteContent = quotesArr[currentQuoteIndex].content
        let resultContent = (content.isNextButtonEnabled, content.isPrevButtonEnabled, quoteContent ?? "No Quote")
        vc?.displayUpdatedCoreData(content: resultContent)
    }
    
    func formatIdeaChange() {
        vc?.displayIdeaChange()
    }
}
