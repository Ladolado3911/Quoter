//
//  SignupVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//


import UIKit
import Combine

protocol SignupVCProtocol: AnyObject {
    var interactor: SignupInteractorProtocol? { get set }
    var router: SignupRouterProtocol? { get set }
    var signupView: SignupView? { get set }
    
    func present(vc: UIViewController)
}

class SignupVC: UIViewController {
    
    var interactor: SignupInteractorProtocol?
    var router: SignupRouterProtocol?
    var signupView: SignupView?
    
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
        view = signupView
        configElements()
        configListeners()
    }
    
    private func setup() {
        let vc = self
        let interactor = SignupInteractor()
        let presenter = SignupPresenter()
        let router = SignupRouter()
        let signupNetworkWorker = SignupNetworkWorker()
        let signupView = SignupView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.signupView = signupView
        vc.router = router
        interactor.presenter = presenter
        interactor.signupNetworkWorker = signupNetworkWorker
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
                self.signupView?.formView.callToActionButton.isEnabled = bool
            }
            .store(in: &cancellables)
        
        emailSubject
            .sink { [weak self] value in
                guard let self = self else { return }
                let emailWidth: CGFloat = value.isValidEmail.1 ? 0 : 1
                self.signupView?.formView.firstInputView.rectView.layer.borderWidth = emailWidth
            }
            .store(in: &cancellables)

        passwordSubject
            .sink { [weak self] value in
                guard let self = self else { return }
                let passwordWidth: CGFloat = value.isValidPassword.1 ? 0 : 1
                self.signupView?.formView.secondInputView.rectView.layer.borderWidth = passwordWidth
            }
            .store(in: &cancellables)
    }
    
    private func configElements() {
        signupView?.arrowButton.addTarget(self, action: #selector(onArrowButton(sender:)), for: .touchUpInside)
        signupView?.formView.callToActionButton.addTarget(self, action: #selector(onSignupButton(sender:)), for: .touchUpInside)
        signupView?.formView.firstInputView.inputTextField.addTarget(self, action: #selector(emailTextFieldDidChange(sender:)), for: .editingChanged)
        signupView?.formView.secondInputView.inputTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(sender:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignupVC {
    
    @objc func onArrowButton(sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func onSignupButton(sender: UIButton) {
        let credentials = UserCredentials(email: trackEmail,
                                          password: trackPassword,
                                          isMailVerified: false,
                                          accountType: AccountType.quotie.rawValue)
        signupView?.startAnimating()
        signupView?.formView.clearData()
        Task.init { [weak self] in
            guard let self = self else { return }
            let response = try await self.interactor?.signupNetworkWorker?.signupUser(user: credentials)
            await MainActor.run {
                var resultMessage: String = ""
                switch response?.response {
                case .success(let idString):
                    guard let id = UUID(uuidString: idString) else { return }
                    CurrentUserLocalManager.shared.persistUserIDAfterSignIn(id: id, type: .quotie)
                    router?.routeToProfileVC()
                case .failure(let message):
                    resultMessage = message
                default:
                    resultMessage = "Try again"
                }
                signupView?.stopAnimating {
                    self.presentAlert(title: "Alert",
                                      text: resultMessage,
                                      mainButtonText: "ok",
                                      mainButtonStyle: .cancel) {
                        
                    }
                }
            }
        }
    }
    
    @objc func emailTextFieldDidChange(sender: UITextField) {
        if sender.text == "" {
            signupView?.formView.firstInputView.rectView.layer.borderWidth = 0
            return
        }
        emailSubject.send(sender.text ?? "")
    }
    
    @objc func passwordTextFieldDidChange(sender: UITextField) {
        if sender.text == "" {
            signupView?.formView.secondInputView.rectView.layer.borderWidth = 0
            return
        }
        passwordSubject.send(sender.text ?? "")
    }
}

extension SignupVC: SignupVCProtocol {
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}
