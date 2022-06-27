//
//  SigninVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit
import Combine

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
    
    let emailSubject = PassthroughSubject<String, Never>()
    let passwordSubject = PassthroughSubject<String, Never>()
    
    var trackEmail = ""
    var trackPassword = ""
    
    var cancellables: Set<AnyCancellable> = []
    
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
        configListeners()
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
    
    private func configListeners() {
        Publishers.CombineLatest(emailSubject, passwordSubject)
            .sink { [weak self] value in
                guard let self = self else { return }
                let bool = value.0.isValidEmail.1 && value.1.isValidPassword.1
                self.trackEmail = value.0
                self.trackPassword = value.1
                self.signinView?.formView.callToActionButton.isEnabled = bool
            }
            .store(in: &cancellables)
        
        emailSubject
            .sink { [weak self] value in
                guard let self = self else { return }
                let emailWidth: CGFloat = value.isValidEmail.1 ? 0 : 1
                self.signinView?.formView.firstInputView.rectView.layer.borderWidth = emailWidth
            }
            .store(in: &cancellables)

        passwordSubject
            .sink { [weak self] value in
                guard let self = self else { return }
                let passwordWidth: CGFloat = value.isValidPassword.1 ? 0 : 1
                self.signinView?.formView.secondInputView.rectView.layer.borderWidth = passwordWidth
            }
            .store(in: &cancellables)
    }
    
    private func configElements() {
        signinView?.signUpButton.addTarget(self, action: #selector(onSignupButton(sender:)), for: .touchUpInside)
        signinView?.formView.callToActionButton.addTarget(self, action: #selector(onSigninButton(sender:)), for: .touchUpInside)
        signinView?.formView.firstInputView.inputTextField.addTarget(self, action: #selector(emailTextFieldDidChange(sender:)), for: .editingChanged)
        signinView?.formView.secondInputView.inputTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(sender:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SigninVC {
    @objc func onSignupButton(sender: UIButton) {
        router?.routeToSignupVC()
    }
    
    @objc func onSigninButton(sender: UIButton) {
        let email = trackEmail
        let password = trackPassword
        
        
    }
    
    @objc func emailTextFieldDidChange(sender: UITextField) {
        if sender.text == "" {
            signinView?.formView.firstInputView.rectView.layer.borderWidth = 0
            return
        }
        emailSubject.send(sender.text ?? "")
    }
    
    @objc func passwordTextFieldDidChange(sender: UITextField) {
        if sender.text == "" {
            signinView?.formView.secondInputView.rectView.layer.borderWidth = 0
            return
        }
        passwordSubject.send(sender.text ?? "")
    }
}

extension SigninVC: SigninVCProtocol {
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}

extension SigninVC: UITextFieldDelegate {
    
}
