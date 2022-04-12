//
//  ModalAlertContentWorker.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/4/22.
//

import UIKit

class ModalAlertContentWorker {
    
    let modalAlertQuoteWorker = ModalAlertQuoteWorker()
    let modalAlertImageWorker = ModalAlertImageWorker()
    
    func getContent(authorName: String, completion: @escaping (([QuoteGardenQuoteModel], (UIImage?, ImageType))) -> Void) {
        
        var resultQuoteModels: [QuoteGardenQuoteModel] = []
        var resultImageTuple: (UIImage?, ImageType) = (nil, .noPicture)
        let group = DispatchGroup()
        
        group.enter()
        modalAlertQuoteWorker.getQuotesOfAuthors(authorName: authorName) { result in
            switch result {
            case .success(let quoteModels):
                resultQuoteModels = quoteModels
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        group.enter()
        modalAlertImageWorker.getAuthorImage(authorName: authorName) { imageTuple in
            resultImageTuple = imageTuple
            group.leave()
        }
        group.notify(queue: .main) {
            completion((resultQuoteModels, (resultImageTuple)))
        }
    }
}
