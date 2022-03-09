//
//  FilterInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/9/22.
//

import UIKit
import TTGTags

protocol VCToFilterInteractorProtocol: AnyObject {
    var presenter: InteractorToFilterPresenterProtocol? { get set }
    
    func requestToPopulateTags()
}

class FilterInteractor: VCToFilterInteractorProtocol {
    var presenter: InteractorToFilterPresenterProtocol?
    
    let filterGenreWorker = FilterGenreWorker()
    
    func requestToPopulateTags() {
        filterGenreWorker.getGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let filterObjects):
                self.presenter?.formatFetchedTags(filterObjects: filterObjects)
            case .failure(let error):
                print(error)
            }
        }
    }
}
