//
//  QoaPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol? { get set }
    
    func formatNetworkData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool)
    func formatCoreData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore])
    func testFormat()
}

class QoaPresenter: InteractorToQoaPresenterProtocol {
    var vc: PresenterToQoaVCProtocol?
    
    func formatNetworkData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, array: [QuoteGardenQuoteVM], currentIndex: Int, isButtonEnabled: Bool) {
        let quoteContent = array[currentIndex].content
        vc?.displayInitialNetworkData(name: name, contentMode: contentMode, exportImage: exportImage, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
    
    func formatCoreData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, currentIndex: Int, array: [QuoteCore]) {
        let quotesArr = author.quotes
        let quoteContent = quotesArr[currentIndex].content ?? "No Quote"
        vc?.displayInitialCoreData(author: author, contentMode: contentMode, isButtonEnabled: isButtonEnabled, quoteContent: quoteContent)
    }
    
    func testFormat() {
        vc?.displayUpdatedData()
    }
}
