//
//  SigninVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit
import SkyFloatingLabelTextField

protocol SigninVCProtocol: AnyObject {
    var interactor: SigninInteractorProtocol? { get set }
    var router: SigninRouterProtocol? { get set }
    var signinView: SigninView? { get set }
    
    func present(vc: UIViewController)
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
        configElements()
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
    
    private func configElements() {
        signinView?.signUpButton.addTarget(self, action: #selector(onSignupButton(sender:)), for: .touchUpInside)
        signinView?.formView.firstInputView.inputTextField.addTarget(self, action: #selector(emailTextFieldDidChange(sender:)), for: .editingChanged)
        signinView?.formView.secondInputView.inputTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(sender:)), for: .editingChanged)
    }
}

extension SigninVC {
    @objc func onSignupButton(sender: UIButton) {
        router?.routeToSignupVC()
    }
    
    @objc func emailTextFieldDidChange(sender: UITextField) {
        let tuple = (sender.text ?? "").isValidEmail
        if !tuple.1 {
            signinView?.formView.firstInputView.backgroundColor = .red
            print(tuple.0)
        }
        else {
            signinView?.formView.firstInputView.backgroundColor = .clear
        }
    }
    
    @objc func passwordTextFieldDidChange(sender: UITextField) {
        let tuple = (sender.text ?? "").isValidPassword
        if !tuple.1 {
            signinView?.formView.secondInputView.backgroundColor = .red
            print(tuple.0)
        }
        else {
            signinView?.formView.secondInputView.backgroundColor = .clear
        }
    }
}

extension SigninVC: SigninVCProtocol {
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}

extension SigninVC: UITextFieldDelegate {
    
}
