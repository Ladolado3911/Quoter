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
    
    var quoteVM: QuoteGardenQuoteVM? {
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
    
    lazy var presentQuotesOfAuthorClosure: (([QuoteGardenQuoteVM], URL?)) -> Void = { [weak self] quoteVMs in
        guard let self = self else { return }
        let destVC = QuotesOfAuthorVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.networkQuotesArr = quoteVMs.0
        destVC.state = .network
        destVC.authorImageURL = quoteVMs.1
        destVC.authorName = self.quoteVM?.authorName
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
    
    var isFirstAppear: Bool = true
    
    override func loadView() {
        super.loadView()
        view = quoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("did load")
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppear {
            isFirstAppear = false
        }
        else {
            quoteView.startAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(quoteView.ideaImageView.gestureRecognizers)
        //CoreDataManager.clearQuotesAndAuthors()
        //print(CoreDataManager.getQuote(quoteVM: quoteVM!)?.content)
        //CoreDataManager.printCoreDataItems()

        
        if let quoteVM = quoteVM {
            let author = CoreDataManager.getAuthor(authorName: quoteVM.authorName)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        quoteView.stopAnimating()
    }
    
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        
        guard let mainImageURl = mainImageURL else {
            return 
        }

        quoteView.ideaImageView.addGestureRecognizer(tapOnIdeaGesture)
        quoteView.bookImageView.addGestureRecognizer(tapOnBookGesture)
        
        
        //quoteView.spinnerView.isHidden = false
        //quoteView.spinnerView.startAnimating()
        quoteView.startAnimating()
        
        quoteView.mainImageView.kf.setImage(with: mainImageURl) { [weak self] _ in
            guard let self = self else { return }
//            self.quoteView.spinnerView.stopAnimating()
//            self.quoteView.spinnerView.isHidden = true
            self.quoteView.stopAnimating()
            self.quoteView.quoteTextView.text = quoteVM.content
            self.quoteView.authorLabel.text = quoteVM.authorName
        }
        view.layoutIfNeeded()
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
    
    @objc func didTapOnIdea(sender: UITapGestureRecognizer) {
        ImageManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVM!.authorName)) { [weak self] result in
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
                            CoreDataManager.removePair(quoteVM: self.quoteVM!)
                            collectionViewUpdateSubject.send {}
                            
                        case .off:
                            self.quoteView.ideaImageView.state = .on
                            // add specified quote to core data
                            
                            if tuple.1 == .nature {
                                CoreDataManager.addPair(quoteVM: self.quoteVM!, authorImageData: UIImage(named: "unknown")!.pngData())
                            }
                            else {
                                CoreDataManager.addPair(quoteVM: self.quoteVM!, authorImageData: image.pngData())
                            }
                            collectionViewUpdateSubject.send {}
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
        modalAlertVC.authorName = quoteVM?.authorName
        modalAlertVC.presentingClosure = presentQuotesOfAuthorClosure
        modalAlertVC.quoteVM = quoteVM
        present(modalAlertVC, animated: false)
    }
}
