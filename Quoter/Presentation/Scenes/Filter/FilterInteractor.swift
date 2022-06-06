//
//  FilterInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterInteractorProtocol {
    var presenter: FilterPresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
}

class FilterInteractor: FilterInteractorProtocol {
    var presenter: FilterPresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
}
