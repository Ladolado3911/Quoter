//
//  NotificationInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol VCToNotificationInteractorProtocol: AnyObject {
    
    var presenter: InteractorToNotificationPresenterProtocol? { get set }
    
}

class NotificationInteractor: VCToNotificationInteractorProtocol {
    
    var presenter: InteractorToNotificationPresenterProtocol?
    
}
