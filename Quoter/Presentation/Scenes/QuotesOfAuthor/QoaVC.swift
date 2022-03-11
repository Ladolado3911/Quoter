//
//  QuotesOfAuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit
import Kingfisher

enum QuotesOfAuthorVCState {
    case network
    case coreData
}

protocol PresenterToQoaVCProtocol {
    var interactor: VCToQoaInteractorProtocol? { get set }
    var router: QoaRouterProtocol? { get set }

    func displayInitialNetworkData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, isButtonEnabled: Bool, quoteContent: String)
    
    func displayInitialCoreData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, quoteContent: String)
    
    func displayUpdatedNetworkData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool, isIdeaButtonSelected: Bool, quoteContent: String))
    
    func displayUpdatedCoreData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool, quoteContent: String))
    func displayIdeaChange()
    func configViewButtons()
    func updateViewState(state: QuotesOfAuthorVCState)
    func dismissView(completion: @escaping () -> Void)
}

class QoaVC: UIViewController {
    
    var interactor: VCToQoaInteractorProtocol?
    var router: QoaRouterProtocol?
    
    let quotesOfAuthorView: QuotesOfAuthorView = {
        let quotesOfAuthorView = QuotesOfAuthorView()
        return quotesOfAuthorView
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
        view = quotesOfAuthorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.requestToconfigViewButtons()
        interactor?.requestToDisplayInitialData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        let vc = self
        let interactor = QoaInteractor()
        let presenter = QoaPresenter()
        let router = QoaRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }

    @objc func onIdeaButton(sender: UIButton) {
        interactor?.requestToChangeIdeaState(isSwitchButtonSelected: quotesOfAuthorView.switchButton.isSelected)
    }
    
    @objc func onDeleteButton(sender: UIButton) {
        interactor?.requestToDelete()
    }
    
    @objc func onCloseButton(sender: UIButton) {
        interactor?.requestToDismissView()
    }
    
    @objc func onNext(sender: UIButton) {
        interactor?.onNext()
    }
    
    @objc func onPrev(sender: UIButton) {
        interactor?.onPrev()
    }
}

extension QoaVC: PresenterToQoaVCProtocol {
    
    func displayInitialNetworkData(name: String, contentMode: UIView.ContentMode, exportImage: UIImage?, isButtonEnabled: Bool, quoteContent: String) {
        quotesOfAuthorView.mainImageView.contentMode = contentMode
        quotesOfAuthorView.mainImageView.image = exportImage
        quotesOfAuthorView.titleOfAuthor.text = name
        quotesOfAuthorView.quoteTextView.text = quoteContent
        quotesOfAuthorView.nextButton.isButtonEnabled = isButtonEnabled
    }
    
    func displayInitialCoreData(author: AuthorCoreVM, contentMode: UIView.ContentMode, isButtonEnabled: Bool, quoteContent: String) {
        quotesOfAuthorView.mainImageView.contentMode = contentMode
        quotesOfAuthorView.titleOfAuthor.text = author.name
        quotesOfAuthorView.mainImageView.image = author.image
        quotesOfAuthorView.quoteTextView.text = quoteContent
        quotesOfAuthorView.nextButton.isButtonEnabled = isButtonEnabled
    }
    
    func displayUpdatedNetworkData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool, isIdeaButtonSelected: Bool, quoteContent: String)) {
        quotesOfAuthorView.nextButton.isButtonEnabled = content.isNextButtonEnabled
        quotesOfAuthorView.prevButton.isButtonEnabled = content.isPrevButtonEnabled
        quotesOfAuthorView.switchButton.isSelected = content.isIdeaButtonSelected
        quotesOfAuthorView.quoteTextView.text = content.quoteContent
    }
    
    func displayUpdatedCoreData(content: (isNextButtonEnabled: Bool, isPrevButtonEnabled: Bool, quoteContent: String)) {
        quotesOfAuthorView.nextButton.isButtonEnabled = content.isNextButtonEnabled
        quotesOfAuthorView.prevButton.isButtonEnabled = content.isPrevButtonEnabled
        quotesOfAuthorView.quoteTextView.text = content.quoteContent
    }
    
    func displayIdeaChange() {
        quotesOfAuthorView.switchButton.isSelected.toggle()
    }
    
    func updateViewState(state: QuotesOfAuthorVCState) {
        quotesOfAuthorView.state = state
    }
    
    func dismissView(completion: @escaping () -> Void) {
        dismiss(animated: true) {
            completion()
        }
    }
    
    func configViewButtons() {
        switch interactor?.state {
        case .network:
            quotesOfAuthorView.switchButton.addTarget(self,
                                                    action: #selector(onIdeaButton(sender:)),
                                                    for: .touchUpInside)
        case .coreData:
            quotesOfAuthorView.switchButton.addTarget(self,
                                                    action: #selector(onDeleteButton(sender:)),
                                                    for: .touchUpInside)
        case .none:
            break
        }
        quotesOfAuthorView.closeButton.addTarget(self,
                                                 action: #selector(onCloseButton(sender:)),
                                                 for: .touchUpInside)
        quotesOfAuthorView.nextButton.addTarget(self,
                                                action: #selector(onNext(sender:)),
                                                for: .touchUpInside)
        quotesOfAuthorView.prevButton.addTarget(self,
                                                action: #selector(onPrev(sender:)),
                                                for: .touchUpInside)
    }
}
