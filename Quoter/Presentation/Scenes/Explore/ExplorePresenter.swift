//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

protocol InteractorToPresenterProtocol: AnyObject {
    var vc: PresenterToVCProtocol? { get set }
    
    func formatData()
}

class ExplorePresenter: InteractorToPresenterProtocol {
    var vc: PresenterToVCProtocol?
    
    func formatData() {
        
    }
}
