//
//  SigninVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

protocol SigninVCProtocol: AnyObject {
    var interactor: SigninInteractorProtocol? { get set }
    var router: SigninRouterProtocol? { get set }
    var signinView: SigninView? { get set }
}

class SigninVC: UIViewController {
    
    var interactor: SigninInteractorProtocol?
    var router: SigninRouterProtocol?
    var signinView: SigninView?
    
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
        view = signinView
        //view.backgroundColor = DarkModeColors.mainBlack
    }
    
    private func setup() {
        let vc = self
        let interactor = SigninInteractor()
        let presenter = SigninPresenter()
        let router = SigninRouter()
        //let exploreNetworkWorker = ExploreNetworkWorker()
        let signinView = SigninView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.signinView = signinView
        vc.router = router
        interactor.presenter = presenter
        //interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
}

extension SigninVC: SigninVCProtocol {
    
}
