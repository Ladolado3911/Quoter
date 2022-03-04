//
//  ModalAlertRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

protocol ModalAlertRouterProtocol {
    var vc: PresenterToModalAlertVCProtocol? { get set }
    
    func routeToQuotesOfAuthor(passingClosure: @escaping (([QuoteGardenQuoteVM], (UIImage?, ImageType))) -> Void,
                               quoteVM: QuoteGardenQuoteVM,
                               authorName: String?,
                               resultTuple: (([QuoteGardenQuoteVM], (UIImage?, ImageType))))
}

class ModalAlertRouter: ModalAlertRouterProtocol {
    
    var vc: PresenterToModalAlertVCProtocol?
    
    func routeToQuotesOfAuthor(passingClosure: @escaping (([QuoteGardenQuoteVM], (UIImage?, ImageType))) -> Void,
                               quoteVM: QuoteGardenQuoteVM,
                               authorName: String?,
                               resultTuple: (([QuoteGardenQuoteVM], (UIImage?, ImageType)))) {
        
        if let vc = vc as? ModalAlertVC {
            vc.dismiss(animated: true) {
//                explore vc routes to quotes of author scene
                passingClosure(resultTuple)
            }
        }
    }
    
}
