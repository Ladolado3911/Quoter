//
//  NotificationPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol InteractorToNotificationPresenterProtocol: AnyObject {
    
    var vc: PresenterToNotificationVCProtocol? { get set }
    
    func demolish(completion: @escaping () -> Void)
    func dismiss(completion: @escaping () -> Void)
    
}

class NotificationPresenter: InteractorToNotificationPresenterProtocol {
    
    var vc: PresenterToNotificationVCProtocol?
    
    func demolish(completion: @escaping () -> Void) {
        vc?.demolish(completion: completion)
    }
    
    func dismiss(completion: @escaping () -> Void) {
        vc?.dismiss(completion: completion)
    }
}
