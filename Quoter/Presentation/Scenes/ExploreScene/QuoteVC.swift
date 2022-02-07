//
//  QuoteVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import Kingfisher
import AVFoundation

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
    
    var mainImageURL: URL?
    var imageType: ImageType?
    
    lazy var presentQuotesOfAuthorClosure: (([AuthorQuoteVM], URL?)) -> Void = { [weak self] quoteVMs in
        guard let self = self else { return }
        let destVC = QuotesOfAuthorVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
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
        //print("did load")
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(quoteView.ideaImageView.gestureRecognizers)
        //CoreDataManager.clearQuotesAndAuthors()
        //print(CoreDataManager.getQuote(quoteVM: quoteVM!)?.content)
        //CoreDataManager.printCoreDataItems()
        if let quoteVM = quoteVM {
            let author = CoreDataManager.getAuthor(authorName: quoteVM.author)
            if let author = author,
               let quotesSet = author.relationship,
               let quotesArr = quotesSet.allObjects as? [QuoteCore] {
                for quote in quotesArr {
                    if quoteVM.content == quote.content && quoteView.ideaImageView.state == .off {
                        quoteView.ideaImageView.state = .on
                    }
                }
            }
        }
//        let str = "\(quoteVM?.content ?? "No Content")."
//        str.speak()
        //"is this ok?".speak()
        
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
//        guard let mainImageURl = mainImageURL else {
//            return
//        }
        quoteView.quoteTextView.text = quoteVM.content
        quoteView.authorLabel.text = quoteVM.author
        quoteView.ideaImageView.addGestureRecognizer(tapOnIdeaGesture)
        quoteView.bookImageView.addGestureRecognizer(tapOnBookGesture)
        //quoteView.mainImageView.kf.setImage(with: mainImageURl)
//        QuoteManager.getRandomImage { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let url):
//                self.quoteView.mainImageView.kf.setImage(with: url)
//            case .failure(let error):
//                print(error)
//            }
//        }
        print(quoteVM.lastTag)
        if quoteVM.lastTag == "famous-quotes" {
            ImageManager.getRandomImage { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                    self.quoteView.mainImageView.kf.setImage(with: url)
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            ImageManager.loadRelevantImageURL(keyword: quoteVM.lastTag) { [weak self] result in
                switch result {
                case .success(let url):
                    self?.quoteView.mainImageView.kf.setImage(with: url)
                case .failure(let error):
                    print(error)
                }
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
        ImageManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVM.author)) { [weak self] result in
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
