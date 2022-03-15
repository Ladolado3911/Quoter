//
//  NotificationPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol InteractorToNotificationPresenterProtocol: AnyObject {
    
    var vc: PresenterToNotificationVCProtocol? { get set }
    
}

class NotificationPresenter: InteractorToNotificationPresenterProtocol {
    
    var vc: PresenterToNotificationVCProtocol?
    
}
