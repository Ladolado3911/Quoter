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
    
    func showView()
}

class AuthorVC: UIViewController {
    var interactor: AuthorInteractorProtocol?
    var router: AuthorRouterProtocol?
    
    lazy var authorView: AuthorView = {
        let autView = AuthorView(frame: view.initialFrame)
        autView.alpha = 0
        return autView
    }()

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
        view.backgroundColor = .clear
        buildSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.showView()
    }
    
    private func buildSubviews() {
        view.addSubview(authorView)
    }
    
    private func setup() {
        let vc = self
        let interactor = AuthorInteractor()
        let presenter = AuthorPresenter()
        let router = AuthorRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }
    
    
}

extension AuthorVC: AuthorVCProtocol {
    func showView() {
        authorView.frame = view.bounds
        authorView.alpha = 1
    }
}

