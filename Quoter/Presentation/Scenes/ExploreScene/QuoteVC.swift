//
//  QuoteVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import Kingfisher

class QuoteVC: UIViewController {
    
    var quoteVM: QuoteVM? {
        didSet {
            configWithVM()
        }
    }
        
    let quoteView: QuoteView = {
        let quoteView = QuoteView()
        return quoteView
    }()
    
    var imageType: ImageType?
    
    lazy var presentQuotesOfAuthorClosure: (([AuthorQuoteVM], URL?)) -> Void = { [weak self] quoteVMs in
        guard let self = self else { return }
        let destVC = QuotesOfAuthorVC()
        destVC.networkQuotesArr = quoteVMs.0
        destVC.state = .network
        destVC.authorImageURL = quoteVMs.1
        destVC.authorName = self.quoteVM?.author
        self.present(destVC, animated: true)
    }
    
    lazy var tapOnIdeaGesture: UITapGestureRecognizer = {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnIdea(sender:)))
        return tapOnGesture
    }()
    
    lazy var tapOnBookGesture: UITapGestureRecognizer = {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnBook(sender:)))
        return tapOnGesture
    }()
    
    override func loadView() {
        super.loadView()
        view = quoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(quoteView.ideaImageView.gestureRecognizers)
        //CoreDataManager.clearQuotesAndAuthors()
        //print(CoreDataManager.getQuote(quoteVM: quoteVM!)?.content)
        //CoreDataManager.printCoreDataItems()
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        quoteView.quoteTextView.text = quoteVM.content
        quoteView.authorLabel.text = quoteVM.author
        quoteView.ideaImageView.addGestureRecognizer(tapOnIdeaGesture)
        quoteView.bookImageView.addGestureRecognizer(tapOnBookGesture)
        QuoteManager.getRandomImage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                self.quoteView.mainImageView.kf.setImage(with: url)
            case .failure(let error):
                print(error)
            }
        }
        view.layoutIfNeeded()
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
    
    @objc func didTapOnIdea(sender: UITapGestureRecognizer) {
        guard let quoteVM = quoteVM else {
            return
        }
        
        var authorImage: UIImage?

//        guard let image = quoteView.mainImageView.image else {
//            return
//        }
//        guard let imageType = imageType else {
//            return
//        }
        QuoteManager.getAuthorImageURLUsingSlug(slug: quoteVM.authorSlug) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tuple):
                do {
                    let data = try Data(contentsOf: tuple.0)
                    if let image = UIImage(data: data) {
                        switch self.quoteView.ideaImageView.state {
                        case .on:
                            self.quoteView.ideaImageView.state = .off
                            // remove specified quote from core data
                            CoreDataManager.removePair(quoteVM: quoteVM)
                            
                        case .off:
                            self.quoteView.ideaImageView.state = .on
                            // add specified quote to core data
                            
                            if self.imageType == .nature {
                                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: UIImage(named: "unknown")!.pngData())
                            }
                            else {
                                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: image.pngData())
                            }
                        }
                    }
                    else {
                        print("Could not unwrap")
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

        
//        switch quoteView.ideaImageView.state {
//        case .on:
//            quoteView.ideaImageView.state = .off
//            // remove specified quote from core data
//            CoreDataManager.removePair(quoteVM: quoteVM)
//
//        case .off:
//            quoteView.ideaImageView.state = .on
//            // add specified quote to core data
//
//            if imageType == .nature {
//                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: UIImage(named: "unknown")!.pngData())
//            }
//            else {
//                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: authorImage!.pngData())
//            }
//        }
        //CoreDataManager.printCoreDataItems()
    }
    
    @objc func didTapOnBook(sender: UITapGestureRecognizer) {
        let modalAlertVC = ModalAlertVC()
        modalAlertVC.modalTransitionStyle = .crossDissolve
        modalAlertVC.modalPresentationStyle = .custom
        modalAlertVC.authorName = quoteVM?.author
        modalAlertVC.authorSlug = quoteVM?.authorSlug
        modalAlertVC.presentingClosure = presentQuotesOfAuthorClosure
        modalAlertVC.quoteVM = quoteVM
        present(modalAlertVC, animated: false)
    }
}
