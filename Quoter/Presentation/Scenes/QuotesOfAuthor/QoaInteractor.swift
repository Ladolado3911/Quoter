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
            let networkSetWorker = QoaNetworkSetWorker()
            let content = networkSetWorker.getContent(defaultImage: defaultImage,
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
            let coreSetWorker = QoaCoreSetWorker()
            let content = coreSetWorker.getContent(author: author, defaultImage: defaultImage)
            presenter?.formatCoreData(author: author,
                                      contentMode: content.contentMode,
                                      isButtonEnabled: content.isButtonEnabled,
                                      currentIndex: currentIndex,
                                      array: quotesArr)
        }
    }
}
