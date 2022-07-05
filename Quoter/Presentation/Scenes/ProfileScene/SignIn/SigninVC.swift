//
//  SigninVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit
import Combine
import AuthenticationServices

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
    
    lazy var onAppleTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(continueWithApple(sender:)))
        return tapGesture
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
        let signinNetworkWorker = SigninNetworkWorker()
        let signupNetworkWorker = SignupNetworkWorker()
        let signinView = SigninView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.signinView = signinView
        vc.router = router
        interactor.presenter = presenter
        interactor.signinNetworkWorker = signinNetworkWorker
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
                self.signinView?.formView.callToActionButton.isEnabled = bool
            }
            .store(in: &cancellables)
    }
    
    private func configElements() {
        signinView?.thirdPartyButtonView2.addGestureRecognizer(onAppleTapGesture)
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
        let credentials = UserCredentials(email: trackEmail,
                                          password: trackPassword,
                                          isMailVerified: false)
        //value required for isMailVerified bug here in backend
        signinView?.formView.clearData()
        signinView?.formView.callToActionButton.startAnimating()
        Task.init { [weak self] in
            guard let self = self else { return }
            var resultResponse: QuotieResponse? = nil
            do {
                resultResponse = try await self.interactor?.signinNetworkWorker?.signinUser(user: credentials)
            }
            catch {
                self.signinView?.formView.callToActionButton.stopAnimating()
                self.presentAlert(title: "Alert",
                                  text: "Unknown error",
                                  mainButtonText: "ok",
                                  mainButtonStyle: .cancel) {
                    
                }
            }
            await MainActor.run { [resultResponse] in
                switch resultResponse?.response {
                case .success(let idString):
                    // show profile VC
                    self.signinView?.formView.callToActionButton.stopAnimating()
                    if let id = UUID(uuidString: idString) {
                        CurrentUserLocalManager.shared.persistUserIDAfterSignIn(id: id)
                        self.router?.routeToProfileVC()
                    }
                    else {
                        break
                    }
                case .failure(let message):
                    self.signinView?.formView.callToActionButton.stopAnimating()
                    self.presentAlert(title: "Alert",
                                      text: message,
                                      mainButtonText: "ok",
                                      mainButtonStyle: .cancel) {
                        
                    }
                default:
                    break
                }
            }
        }
        
    }
    
    @objc func emailTextFieldDidChange(sender: UITextField) {
        emailSubject.send(sender.text ?? "")
    }
    
    @objc func passwordTextFieldDidChange(sender: UITextField) {
        passwordSubject.send(sender.text ?? "")
    }
    
    @objc func continueWithApple(sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.presentationContextProvider = self
        controller.delegate = self
        controller.performRequests()
    }
    
    @objc func continueWithGoogle(sender: UIButton) {
        
    }
}

extension SigninVC: SigninVCProtocol {
    func present(vc: UIViewController) {
        present(vc, animated: true)
    }
}

extension SigninVC: UITextFieldDelegate {
    
}

extension SigninVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let mail = credentials.email
            interactor?.signupIfNeeded(email: mail) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let idString):
                    let id = UUID(uuidString: idString)!
                    CurrentUserLocalManager.shared.persistUserIDAfterSignIn(id: id)
                    self.router?.routeToProfileVC()
                case .failure:
                    Task.init {
                        let userCredentials = UserCredentials(email: mail ?? "No Email", password: "", isMailVerified: true)
                        let response = try await self.interactor?.signinNetworkWorker?.signinUser(user: userCredentials)
                        await MainActor.run {
                            switch response?.response {
                            case .success(let idString):
                                let id = UUID(uuidString: idString)!
                                CurrentUserLocalManager.shared.persistUserIDAfterSignIn(id: id)
                                self.router?.routeToProfileVC()
                            case .failure(let errorMessage):
                                self.presentAlert(title: "Alert",
                                                  text: errorMessage,
                                                  mainButtonText: "ok",
                                                  mainButtonStyle: .cancel) {
                                    
                                }
                            default:
                                break
                            }
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

extension SigninVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
