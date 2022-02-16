//
//  QuoteVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import Kingfisher

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
    var isVCLoaded: Bool = false
    
    lazy var presentQuotesOfAuthorClosure: (([QuoteGardenQuoteVM], UIImage?, QuoteGardenQuoteVM)) -> Void = { [weak self] quoteVMs in
        guard let self = self else { return }
        let destVC = QuotesOfAuthorVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.networkQuotesArr = quoteVMs.0
        destVC.state = .network
        destVC.networkAuthorImage = quoteVMs.1
       // destVC.authorImageURL = quoteVMs.1
        destVC.authorName = self.quoteVM?.authorName
        destVC.quoteVM = quoteVMs.2
        self.present(destVC, animated: true)
    }

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
            if quoteView.lottieAnimation.isAnimationPlaying {
                quoteView.stopAnimating()
                quoteView.startAnimating()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(NetworkMonitor.shared.isConnected)
        //print(quoteView.ideaImageView.gestureRecognizers)
        //CoreDataManager.clearQuotesAndAuthors()
        //print(CoreDataManager.getQuote(quoteVM: quoteVM!)?.content)
        //CoreDataManager.printCoreDataItems()

        
//        if let quoteVM = quoteVM {
//            let author = CoreDataManager.getAuthor(authorName: quoteVM.authorName)
//            if let author = author,
//               let quotesSet = author.relationship,
//               let quotesArr = quotesSet.allObjects as? [QuoteCore] {
//                for quote in quotesArr {
//                    if quoteVM.content == quote.content && quoteView.ideaImageView.state == .off {
//                        quoteView.ideaImageView.state = .on
//                    }
//                }
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        quoteView.stopAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        quoteView.darkView.isHidden = false
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        guard let mainImageURl = mainImageURL else {
            return 
        }
        quoteView.bookImageView.addGestureRecognizer(tapOnBookGesture)
        quoteView.startAnimating()
        quoteView.mainImageView.kf.setImage(with: mainImageURl) { [weak self] _ in
            guard let self = self else { return }
            self.quoteView.stopAnimating()
            self.quoteView.quoteTextView.text = quoteVM.content
            self.quoteView.authorLabel.text = quoteVM.authorName
        }
        view.layoutIfNeeded()
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
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
