//
//  ModalAlertVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

class ModalAlertVC: UIViewController {
    
    var authorName: String?
    var authorSlug: String?
    
    var presentingClosure: ((([AuthorQuoteVM], UIImage?)) -> Void)?
    
    let modalAlertView: ModalAlertView = {
        let modalAlertView = ModalAlertView()
        return modalAlertView
    }()
    
    override func loadView() {
        super.loadView()
        view = modalAlertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modalAlertView.buildView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let authorName = authorName,
           let slug = authorSlug {
            modalAlertView.buildView(authorName: authorName)
            QuoteManager.getQuotesOfAuthor(authorSlug: slug, page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let quotes):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true) {
                            if let presentingClosure = self.presentingClosure {
                                presentingClosure((quotes, nil))
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
