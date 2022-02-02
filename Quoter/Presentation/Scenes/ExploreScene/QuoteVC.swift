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
        CoreDataManager.printCoreDataItems()
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        quoteView.quoteTextView.text = quoteVM.content
        quoteView.authorLabel.text = quoteVM.author
        quoteView.ideaImageView.addGestureRecognizer(tapOnIdeaGesture)
        quoteView.bookImageView.addGestureRecognizer(tapOnBookGesture)
        QuoteManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVM.author)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tuple):
                self.quoteView.mainImageView.kf.setImage(with: tuple.0)
                self.imageType = tuple.1
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
        guard let image = quoteView.mainImageView.image else {
            return
        }
        guard let imageType = imageType else {
            return
        }
        switch quoteView.ideaImageView.state {
        case .on:
            quoteView.ideaImageView.state = .off
            // remove specified quote from core data
            CoreDataManager.removePair(quoteVM: quoteVM)
            
        case .off:
            quoteView.ideaImageView.state = .on
            // add specified quote to core data
            
            if imageType == .nature {
                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: UIImage(named: "unknown")!.pngData())
            }
            else {
                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: image.pngData())
            }
        }
        CoreDataManager.printCoreDataItems()
    }
    
    @objc func didTapOnBook(sender: UITapGestureRecognizer) {
        print("book")
    }
}
