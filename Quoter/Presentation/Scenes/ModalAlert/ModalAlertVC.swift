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
        let group = DispatchGroup()
        let customQueue = DispatchQueue.global(qos: .background)
        if let authorName = authorName,
           let quoteVMM = quoteVM {
            modalAlertView.buildView(authorName: authorName)
            group.enter()
            ImageManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVMM.authorName)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tuple):
                    if tuple.1 == .author {
                        guard let url = tuple.0 else { return }
                        group.enter()
                        customQueue.async {
                            do {
                                let imageData = try Data(contentsOf: url)
                                let image = UIImage(data: imageData)
                                DispatchQueue.main.async {
                                    self.authorImage = image
                                    group.leave()
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
            group.enter()
            QuoteGardenManager.getQuotesOfAuthor(authorName: quoteVMM.authorName) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let quotes):
                    group.leave()
                    group.notify(queue: .main) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            self.dismiss(animated: true) {
                                if let presentingClosure = self.presentingClosure,
                                   let authorImage = self.authorImage {
                                    presentingClosure((quotes, authorImage, quoteVMM))
                                }
                                else {
                                    self.presentingClosure!((quotes, nil, quoteVMM))
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
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
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
}

extension ModalAlertVC: PresenterToModalAlertVCProtocol {
    
}
