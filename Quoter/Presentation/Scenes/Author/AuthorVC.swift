//
//  AuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit


protocol AuthorVCProtocol: AnyObject {
    var interactor: AuthorInteractorProtocol? { get set }
    var router: AuthorRouterProtocol? { get set }
    var authorView: AuthorView? { get set }
    
  
}

class AuthorVC: UIViewController {
    var interactor: AuthorInteractorProtocol?
    var router: AuthorRouterProtocol?
    var authorView: AuthorView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let vc = self
        let interactor = AuthorInteractor()
        let presenter = AuthorPresenter()
        let router = AuthorRouter()
        let authorView = AuthorView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.authorView = authorView
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }
    
    
}

extension AuthorVC: AuthorVCProtocol {
    
}

