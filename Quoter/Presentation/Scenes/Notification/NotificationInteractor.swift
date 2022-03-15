//
//  NotificationInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol VCToNotificationInteractorProtocol: AnyObject {
    
    var presenter: InteractorToNotificationPresenterProtocol? { get set }
    
    func demolishView(completion: @escaping () -> Void)
    func dismiss()
    
}

class NotificationInteractor: VCToNotificationInteractorProtocol {
    
    var presenter: InteractorToNotificationPresenterProtocol?
    
    func demolishView(completion: @escaping () -> Void) {
        presenter?.demolish(completion: completion)
    }
    
    func dismiss() {
        presenter?.dismiss()
    }
    
}
