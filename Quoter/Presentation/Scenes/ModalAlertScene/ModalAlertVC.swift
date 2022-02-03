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
    var quoteVM: QuoteVM?
    var authorImageURL: URL?
    
    var presentingClosure: ((([AuthorQuoteVM], URL?)) -> Void)?
    
    let modalAlertView: ModalAlertView = {
        let modalAlertView = ModalAlertView()
        return modalAlertView
    }()
    
    override func loadView() {
        super.loadView()
        view = modalAlertView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let semaphore = DispatchSemaphore(value: 1)
        if let authorName = authorName,
           let slug = authorSlug,
           let quoteVMM = quoteVM {
            modalAlertView.buildView(authorName: authorName)
            QuoteManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVMM.author)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tuple):
                    self.authorImageURL = tuple.0
                    semaphore.signal()
                case .failure(let error):
                    print(error)
                    semaphore.signal()
                }
            }
            QuoteManager.getQuotesOfAuthor(authorSlug: slug, page: 1) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let quotes):
                    semaphore.wait()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        self.dismiss(animated: true) {
                            if let presentingClosure = self.presentingClosure,
                               let imageUrl = self.authorImageURL {
                                presentingClosure((quotes, imageUrl))
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
}
