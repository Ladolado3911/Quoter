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
    
    override func loadView() {
        super.loadView()
        view = quoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func configWithVM() {
        guard let quoteVM = quoteVM else {
            return
        }
        quoteView.quoteTextView.text = quoteVM.content
        print(quoteVM.author)
        QuoteManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: quoteVM.author)) { [weak self] result in
            
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
}
