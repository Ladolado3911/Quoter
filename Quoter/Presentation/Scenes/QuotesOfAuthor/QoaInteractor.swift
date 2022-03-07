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
    
    func requestToDisplayUpdatedData()
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
        
        let defaultImage = UIImage(named: "testUpperQuotism")
        switch state {
        case .network:
            guard let name = authorName else { return }
            let content = networkSetWorker.getInitialContent(defaultImage: defaultImage,
                                                      networkAuthorImage: networkAuthorImage,
                                                      networkArray: networkArray)
            presenter?.formatNetworkData(name: name,
                                         contentMode: content.contentMode,
                                         exportImage: content.exportImage,
                                         array: networkArray,
                                         currentIndex: currentIndex,
                                         isButtonEnabled: content.isButtonEnabled)
            
        case .coreData:
            guard let author = author else { return }
            let content = coreSetWorker.getInitialContent(author: author, defaultImage: defaultImage)
            presenter?.formatCoreData(author: author,
                                      contentMode: content.contentMode,
                                      isButtonEnabled: content.isButtonEnabled,
                                      currentIndex: currentIndex,
                                      array: quotesArr)
        }
    }
    
    func requestToDisplayUpdatedData(state: QuotesOfAuthorVCState) {
        switch state {
        case .network:
            quotesOfAuthorView.quoteTextView.text = networkQuotesArr[currentQuoteIndex].content
            quotesOfAuthorView.nextButton.isButtonEnabled = !(currentQuoteIndex == networkQuotesArr.count - 1)
            
//            if currentQuoteIndex == networkQuotesArr.count - 1 {
//                quotesOfAuthorView.nextButton.isButtonEnabled = false
//            }
//            if currentQuoteIndex > 0 {
//                quotesOfAuthorView.prevButton.isButtonEnabled = true
//            }
//            if currentQuoteIndex == 0 {
//                quotesOfAuthorView.prevButton.isButtonEnabled = false
//            }
            let content = networkSetWorker.getUpdatedContent(currentQuoteIndex: <#T##Int#>, networkQuotesArr: <#T##[QuoteGardenQuoteVM]#>)
            quotesOfAuthorView.ideaButton.isSelected = CoreDataWorker.isQuoteInCoreData(quoteVM: networkQuotesArr[currentQuoteIndex])
        case .coreData:
            quotesOfAuthorView.quoteTextView.text = quotesArr[currentQuoteIndex].content
            quotesOfAuthorView.nextButton.isButtonEnabled = !(currentQuoteIndex == networkQuotesArr.count - 1)
//            if currentQuoteIndex == quotesArr.count - 1 {
//                quotesOfAuthorView.nextButton.isButtonEnabled = false
//            }
//            if currentQuoteIndex > 0 {
//                quotesOfAuthorView.prevButton.isButtonEnabled = true
//            }
//            if currentQuoteIndex == 0 {
//                quotesOfAuthorView.prevButton.isButtonEnabled = false
//            }
            let content = coreSetWorker.getUpdatedContent(currentQuoteIndex: <#T##Int#>, quotesArr: <#T##[QuoteCore]#>)
        }
        presenter?.testFormat()
    }
}
