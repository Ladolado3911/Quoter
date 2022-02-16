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
    var authorImage: UIImage?
    
    var presentingClosure: ((([QuoteGardenQuoteVM], UIImage?, QuoteGardenQuoteVM)) -> Void)?
    
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
        //let semaphore = DispatchSemaphore(value: 1)
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
                        group.enter()
                        customQueue.async {
                            do {
                                let imageData = try Data(contentsOf: tuple.0)
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
//                    semaphore.signal()
                    group.leave()
                case .failure(let error):
                    print(error)
                    //semaphore.signal()
                    group.leave()
                }
            }
            group.enter()
            QuoteGardenManager.getQuotesOfAuthor(authorName: quoteVMM.authorName) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let quotes):
                    //semaphore.wait()
                    group.leave()
                    group.notify(queue: .main) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            self.dismiss(animated: true) {
                                if let presentingClosure = self.presentingClosure,
                                   let authorImage = self.authorImage {
                                   //let imageUrl = self.authorImageURL {
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
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
}
