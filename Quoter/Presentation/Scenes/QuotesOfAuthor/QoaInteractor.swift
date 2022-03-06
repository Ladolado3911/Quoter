//
//  QoaInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol VCToQoaInteractorProtocol {
    var presenter: InteractorToQoaPresenterProtocol? { get set }
    
    func requestToDisplayInitialData(state: QuotesOfAuthorVCState,
                              author: AuthorCoreVM?,
                              authorName: String?,
                              networkAuthorImage: UIImage?,
                              networkArray: [QuoteGardenQuoteVM],
                              quotesArr: [QuoteCore],
                              currentIndex: Int)
}

class QoaInteractor: VCToQoaInteractorProtocol {
    var presenter: InteractorToQoaPresenterProtocol?
    
    func requestToDisplayInitialData(state: QuotesOfAuthorVCState,
                              author: AuthorCoreVM?,
                              authorName: String?,
                              networkAuthorImage: UIImage?,
                              networkArray: [QuoteGardenQuoteVM],
                              quotesArr: [QuoteCore],
                              currentIndex: Int) {
        
        let defaultImage = UIImage(named: "testUpperQuotism")
        switch state {
        case .network:
            guard let name = authorName else { return }

            var contentMode: UIView.ContentMode
            var exportImage: UIImage?
            var isButtonEnabled: Bool = false
            
            if networkAuthorImage == nil {
                contentMode = .scaleAspectFit
                exportImage = defaultImage
            }
            else {
                contentMode = .scaleAspectFill
                exportImage = networkAuthorImage
            }
            if networkArray.count > 1 {
                print("more than 1 qoute network")
                isButtonEnabled = true
            }
            presenter?.formatNetworkData(name: name, contentMode: contentMode, exportImage: exportImage, array: networkArray, currentIndex: currentIndex, isButtonEnabled: isButtonEnabled)
            
        case .coreData:
            guard let author = author else { return }

            var contentMode: UIView.ContentMode
            var isButtonEnabled: Bool = false
            
            if author.image.pngData() == defaultImage?.pngData() {
                contentMode = .scaleAspectFit
            }
            else {
                contentMode = .scaleAspectFill
            }
            if author.quotes.count > 1 {
                isButtonEnabled = true
                print("more than 1 qoute core")
            }
            presenter?.formatCoreData(author: author, contentMode: contentMode, isButtonEnabled: isButtonEnabled, currentIndex: currentIndex, array: quotesArr)
        }
    }
}
