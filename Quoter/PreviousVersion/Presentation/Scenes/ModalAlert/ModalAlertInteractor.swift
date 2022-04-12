//
//  ModalAlertInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol VCToModalAlertInteractorProtocol {
    var presenter: InteractorToModalAlertPresenterProtocol? { get set }
    
    func requestDataForRouterAndRoute(authorName: String?, quoteVM: QuoteGardenQuoteVM?)
}

class ModalAlertInteractor: VCToModalAlertInteractorProtocol {
    
    var presenter: InteractorToModalAlertPresenterProtocol?
    
    func requestDataForRouterAndRoute(authorName: String?, quoteVM: QuoteGardenQuoteVM?) {
        let modalAlertContentWorker = ModalAlertContentWorker()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            if let authorName = authorName,
               let quoteVMM = quoteVM {
                modalAlertContentWorker.getContent(authorName: authorName) { [weak self] resultTuple in
                    self?.presenter?.formatContent(authorName: authorName,resultTuple: resultTuple)
                }
            }
        }
    }
}
