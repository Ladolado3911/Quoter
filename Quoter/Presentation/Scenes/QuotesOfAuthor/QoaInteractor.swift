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
    
    func requestToDisplayUpdatedData(state: QuotesOfAuthorVCState, networkQuotesArr: [QuoteGardenQuoteVM], currentQuoteIndex: Int, quotesArr: [QuoteCore])
}

class QoaInteractor: VCToQoaInteractorProtocol {
    var presenter: InteractorToQoaPresenterProtocol?
    
    let networkSetWorker = QoaNetworkSetWorker()
    let coreSetWorker = QoaCoreSetWorker()
    
    func requestToDisplayInitialData(state: QuotesOfAuthorVCState,
                              author: AuthorCoreVM?,
                              authorName: String?,
                              networkAuthorImage: UIImage?,
                              networkArray: [QuoteGardenQuoteVM],
                              quotesArr: [QuoteCore],
                              currentIndex: Int) {
        
        switch state {
        case .network:
            guard let name = authorName else { return }
            let content = networkSetWorker.getInitialContent(defaultImage: defaultImage,
                                                      networkAuthorImage: networkAuthorImage,
                                                      networkArray: networkArray)
            presenter?.formatNetworkInitialData(name: name,
                                         contentMode: content.contentMode,
                                         exportImage: content.exportImage,
                                         array: networkArray,
                                         currentIndex: currentIndex,
                                         isButtonEnabled: content.isButtonEnabled)
            
        case .coreData:
            guard let author = author else { return }
            let content = coreSetWorker.getInitialContent(author: author, defaultImage: defaultImage)
            presenter?.formatCoreInitialData(author: author,
                                      contentMode: content.contentMode,
                                      isButtonEnabled: content.isButtonEnabled,
                                      currentIndex: currentIndex,
                                      array: quotesArr)
        }
    }
    
    func requestToDisplayUpdatedData(state: QuotesOfAuthorVCState, networkQuotesArr: [QuoteGardenQuoteVM], currentQuoteIndex: Int, quotesArr: [QuoteCore]) {
        switch state {
        case .network:
            let quoteVM = networkQuotesArr[currentQuoteIndex]
            let quoteContent = quoteVM.content
            let content = networkSetWorker.getUpdatedContent(currentQuoteIndex: currentQuoteIndex, networkQuotesArr: networkQuotesArr)
            let isIdeaButtonSelected = CoreDataWorker.isQuoteInCoreData(quoteVM: quoteVM)
            presenter?.formatNetworkUpdatedData(content: content, isIdeaButtonEnabled: isIdeaButtonSelected, quoteContent: quoteContent)
        case .coreData:
            let content = coreSetWorker.getUpdatedContent(currentQuoteIndex: currentQuoteIndex, quotesArr: quotesArr, networkArr: networkQuotesArr)
            presenter?.formatCoreUpdatedData(content: content, quotesArr: quotesArr, currentQuoteIndex: currentQuoteIndex)
        }
    }
}
