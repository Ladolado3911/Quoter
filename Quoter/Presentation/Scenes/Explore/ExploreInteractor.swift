//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func requestToDisplayInitialData()
}

class ExploreInteractor: VCToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func requestToDisplayInitialData() {
        let contentWorker = ContentWorker()
        contentWorker.getContent { [weak self] quoteModels, images in
            guard let self = self else { return }
            self.presenter?.formatData(quoteModels: quoteModels, images: images)
        }
    }
}
