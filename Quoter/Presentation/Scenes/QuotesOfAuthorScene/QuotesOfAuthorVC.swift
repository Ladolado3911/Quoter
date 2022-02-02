//
//  QuotesOfAuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit

class QuotesOfAuthorVC: UIViewController {
    
    var author: AuthorCoreVM?
    var quotesArr: [QuoteCore] = [] {
        didSet {
            
        }
    }
    
    let quotesOfAuthorView: QuotesOfAuthorView = {
        let quotesOfAuthorView = QuotesOfAuthorView()
        return quotesOfAuthorView
    }()
    
    override func loadView() {
        super.loadView()
        view = quotesOfAuthorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCloseButton()
        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configCloseButton() {
        quotesOfAuthorView.closeButton.addTarget(self,
                                                 action: #selector(onCloseButton(sender:)),
                                                 for: .touchUpInside)
    }
    
    private func populateData() {
        guard let author = author else {
            return
        }
        quotesOfAuthorView.titleOfAuthor.text = author.name
        quotesOfAuthorView.mainImageView.image = author.image
        quotesArr = author.quotes
    }
    
    @objc func onCloseButton(sender: UIButton) {
        dismiss(animated: true)
    }
}
