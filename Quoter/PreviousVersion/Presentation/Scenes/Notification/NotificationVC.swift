//
//  NotificationVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

protocol PresenterToNotificationVCProtocol: AnyObject {
    
    var interactor: VCToNotificationInteractorProtocol? { get set }
    
    func demolish(completion: @escaping () -> Void)
    func dismiss(completion: @escaping () -> Void)
}

class NotificationVC: UIViewController {
    
    var interactor: VCToNotificationInteractorProtocol?
    
    lazy var tapOnBackgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapOnClose(sender:)))
        return gesture
    }()
    
    lazy var notificationView: NotificationView = {
        let notificationView = NotificationView(frame: view.initialFrame, finalFrame: modalFinalFrame)
        return notificationView
    }()
    
    lazy var modalFinalFrame: CGRect = {
        let width = PublicConstants.screenWidth * 0.85
        let height = width * 1.5
        let x = view.bounds.width / 2 - (width / 2)
        let y = view.bounds.height / 2 - (height / 2)
        return CGRect(x: x, y: y, width: width, height: height)
    }()
    
    lazy var darkView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func loadView() {
        super.loadView()
        Sound.pop.play(extensionString: .wav)
        darkView.addGestureRecognizer(tapOnBackgroundGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildView()
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
    
    private func buildView() {
        view.addSubview(darkView)
        view.addSubview(notificationView)
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.notificationView.frame = self.modalFinalFrame
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.notificationView.buildView()
                self.notificationView.closeButton.addTarget(self,
                                                      action: #selector(self.didTapOnClose(sender:)),
                                                      for: .touchUpInside)
            }
        }
    }
    
    @objc func didTapOnClose(sender: UIButton) {
        interactor?.demolishView { [weak self] in
            guard let self = self else { return }
            self.interactor?.dismiss()
        }
    }
}

extension NotificationVC: PresenterToNotificationVCProtocol {
    func demolish(completion: @escaping () -> Void) {
        notificationView.demolishView {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.notificationView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            } completion: { didFinish in
                if didFinish {
                    completion()
                }
            }
        }
    }
    
    func dismiss(completion: @escaping () -> Void) {
        dismiss(animated: true) {
            completion()
        }
    }
}
