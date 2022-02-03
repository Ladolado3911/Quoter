//
//  QuotesOfAuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit

enum QuotesOfAuthorVCState {
    case network
    case coreData
}

class QuotesOfAuthorVC: UIViewController {
    
    var state: QuotesOfAuthorVCState = .coreData
    var author: AuthorCoreVM?
    var currentQuoteIndex: Int = 0 {
        didSet {
            updateQuote()
        }
    }
    var quotesArr: [QuoteCore] = []
    
    var networkQuotesArr: [AuthorQuoteVM] = []
    var authorImage: UIImage?
    
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
        configButtons()
        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configButtons() {
        configCloseButton()
        configNextButton()
        configPrevButton()
    }
    
    private func configCloseButton() {
        quotesOfAuthorView.closeButton.addTarget(self,
                                                 action: #selector(onCloseButton(sender:)),
                                                 for: .touchUpInside)
    }
    
    private func configNextButton() {
        quotesOfAuthorView.nextButton.addTarget(self,
                                                action: #selector(onNext(sender:)),
                                                for: .touchUpInside)
    }
    
    private func configPrevButton() {
        quotesOfAuthorView.prevButton.addTarget(self,
                                                action: #selector(onPrev(sender:)),
                                                for: .touchUpInside)
    }
    
    private func populateData() {
        switch state {
        case .network:
            guard let authorImage = authorImage else {
                return
            }
            quotesOfAuthorView.mainImageView.image = authorImage
            quotesOfAuthorView.quoteTextView.text = networkQuotesArr[currentQuoteIndex].content
        case .coreData:
            guard let author = author else {
                return
            }
            quotesOfAuthorView.titleOfAuthor.text = author.name
            quotesOfAuthorView.mainImageView.image = author.image
            quotesArr = author.quotes
            quotesOfAuthorView.quoteTextView.text = quotesArr[currentQuoteIndex].content
        }
    }
    
    private func updateQuote() {
        switch state {
        case .network:
            quotesOfAuthorView.quoteTextView.text = networkQuotesArr[currentQuoteIndex].content
        case .coreData:
            quotesOfAuthorView.quoteTextView.text = quotesArr[currentQuoteIndex].content
        }
    }
    
    @objc func onCloseButton(sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func onNext(sender: UIButton) {
        switch state {
        case .network:
            if currentQuoteIndex + 1 >= networkQuotesArr.count {
                return
            }
            currentQuoteIndex += 1
        case .coreData:
            if currentQuoteIndex + 1 >= quotesArr.count {
                return
            }
            currentQuoteIndex += 1
        }
    }
    
    @objc func onPrev(sender: UIButton) {
        switch state {
        case .network:
            if currentQuoteIndex - 1 < 0 {
                return
            }
            currentQuoteIndex -= 1
        case .coreData:
            if currentQuoteIndex - 1 < 0 {
                return
            }
            currentQuoteIndex -= 1
        }
    }
}
