//
//  ModalAlertVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

protocol PresenterToModalAlertVCProtocol {
    var interactor: VCToModalAlertInteractorProtocol? { get set }
    var router: ModalAlertRouterProtocol? { get set }
    
    func requestedDataForExploreRouterAndRoute(authorName: String, resultTuple: (([QuoteGardenQuoteVM], (UIImage?, ImageType))))
}

class ModalAlertVC: UIViewController {
    
    var interactor: VCToModalAlertInteractorProtocol?
    var router: ModalAlertRouterProtocol?
    
    var authorName: String?
    var authorSlug: String?
    var quoteVM: QuoteGardenQuoteVM?
    var authorImageURL: URL?
    var authorImage: UIImage?
    
    var presentingClosure: ((([QuoteGardenQuoteVM], UIImage?, QuoteGardenQuoteVM)) -> Void)?
    var passingClosure: ((([QuoteGardenQuoteVM], (UIImage?, ImageType))) -> Void)?
    
    let modalAlertView: ModalAlertView = {
        let modalAlertView = ModalAlertView()
        return modalAlertView
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
        view = modalAlertView
        Sound.pop.play(extensionString: .wav)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalAlertView.buildView(authorName: authorName ?? "")
        interactor?.requestDataForRouterAndRoute(authorName: authorName, quoteVM: quoteVM)
    }
    
    private func setup() {
        let vc = self
        let interactor = ModalAlertInteractor()
        let presenter = ModalAlertPresenter()
        let router = ModalAlertRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }
}

extension ModalAlertVC: PresenterToModalAlertVCProtocol {
    func requestedDataForExploreRouterAndRoute(authorName: String, resultTuple: (([QuoteGardenQuoteVM], (UIImage?, ImageType)))) {
        if let passingClosure = passingClosure {
            router?.routeToQuotesOfAuthor(passingClosure: passingClosure,
                                          quoteVM: quoteVM!,
                                          authorName: authorName,
                                          resultTuple: resultTuple)
        }
    }
}
