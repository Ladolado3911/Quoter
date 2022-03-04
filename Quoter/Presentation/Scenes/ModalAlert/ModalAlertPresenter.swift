//
//  ModalAlertPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol InteractorToModalAlertPresenterProtocol {
    var vc: PresenterToModalAlertVCProtocol? { get set }
    
    func formatContent(authorName: String, resultTuple: ([QuoteGardenQuoteModel], (UIImage?, ImageType)))
}

class ModalAlertPresenter: InteractorToModalAlertPresenterProtocol {
    var vc: PresenterToModalAlertVCProtocol?
    
    func formatContent(authorName: String, resultTuple: ([QuoteGardenQuoteModel], (UIImage?, ImageType))) {
        let unified = Array(Set(resultTuple.0))
        let converted = unified.map { QuoteGardenQuoteVM(rootModel: $0) }
        let filtered = converted.filter { $0.authorName == authorName }
        let shuffledVMs = filtered.shuffled()
        vc?.requestedDataForExploreRouterAndRoute(authorName: authorName, resultTuple: ((shuffledVMs, resultTuple.1)))
    }
}
