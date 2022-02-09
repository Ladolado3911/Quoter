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
    var quoteVM: QuoteGardenQuoteVM?
    var authorImageURL: URL?
    
    var presentingClosure: ((([QuoteGardenQuoteVM], URL?)) -> Void)?
    
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
           let quoteVMM = quoteVM {
            
            modalAlertView.buildView(authorName: authorName)
            ImageManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVMM.authorName)) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let tuple):
                    if tuple.1 == .author {
                        self.authorImageURL = tuple.0
                    }
                    semaphore.signal()
                case .failure(let error):
                    print(error)
                    semaphore.signal()
                }
            }
//            DictumManager.getQuotesOfAuthor(authorID: quoteVMM.authorID) { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let quotes):
//                    semaphore.wait()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
//                        self.dismiss(animated: true, completion: {
//                            if let presentingClosure = self.presentingClosure,
//                               let imageUrl = self.authorImageURL {
//                                presentingClosure((quotes, imageUrl))
//                            }
//                            else {
//                                self.presentingClosure!((quotes, nil))
//                            }
//                        })
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
            QuoteGardenManager.getQuotesOfAuthor(authorName: quoteVMM.authorName) { [weak self] result in
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
                            else {
                                self.presentingClosure!((quotes, nil))
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
