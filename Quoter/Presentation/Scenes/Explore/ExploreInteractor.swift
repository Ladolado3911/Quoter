//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol VCToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
}

class ExploreInteractor: VCToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
}
