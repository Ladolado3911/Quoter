//
//  SignupVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//


import UIKit

protocol SignupVCProtocol: AnyObject {
    var interactor: SignupInteractorProtocol? { get set }
    var router: SignupRouterProtocol? { get set }
    var signupView: SignupView? { get set }
}

class SignupVC: UIViewController {
    
    var interactor: SignupInteractorProtocol?
    var router: SignupRouterProtocol?
    var signupView: SignupView?
    
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
        view = signupView
        configButtons()
    }
    
    private func setup() {
        let vc = self
        let interactor = SignupInteractor()
        let presenter = SignupPresenter()
        let router = SignupRouter()
        //let exploreNetworkWorker = ExploreNetworkWorker()
        let signupView = SignupView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.signupView = signupView
        vc.router = router
        interactor.presenter = presenter
        //interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
    
    private func configButtons() {
        signupView?.arrowButton.addTarget(self, action: #selector(onArrowButton(sender:)), for: .touchUpInside)
    }
}

extension SignupVC {
    @objc func onArrowButton(sender: UIButton) {
        dismiss(animated: true)
    }
}

extension SignupVC: SignupVCProtocol {
    
}
