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
    
    lazy var tapOnIdeaGesture: UITapGestureRecognizer = {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnIdea(sender:)))
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
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        quoteView.quoteTextView.text = quoteVM.content
        quoteView.authorLabel.text = quoteVM.author
        quoteView.ideaImageView.addGestureRecognizer(tapOnIdeaGesture)
        QuoteManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVM.author)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                print(url.absoluteString)
                
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
        switch quoteView.ideaImageView.state {
        case .on:
            quoteView.ideaImageView.state = .off
            // remove specified quote from core data
            
            
        case .off:
            quoteView.ideaImageView.state = .on
            // add specified quote to core data
            
            
        }
    }
}
