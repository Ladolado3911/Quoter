//
//  NotificationVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol PresenterToNotificationVCProtocol: AnyObject {
    
    var interactor: VCToNotificationInteractorProtocol? { get set }
    
    
}



class NotificationVC: UIViewController {
    
    var interactor: VCToNotificationInteractorProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setup() {
        let vc = self
        let interactor = NotificationInteractor()
        let presenter = NotificationPresenter()
        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.vc = vc
    }
}

extension NotificationVC: PresenterToNotificationVCProtocol {
    
}
