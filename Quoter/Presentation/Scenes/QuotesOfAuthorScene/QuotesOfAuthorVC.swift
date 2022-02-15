//
//  QuotesOfAuthorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit
import Kingfisher

enum QuotesOfAuthorVCState {
    case network
    case coreData
}

class QuotesOfAuthorVC: UIViewController {
    
    var state: QuotesOfAuthorVCState = .coreData {
        didSet {
            quotesOfAuthorView.state = state
        }
    }
    var author: AuthorCoreVM?
    var currentQuoteIndex: Int = 0 {
        didSet {
            updateQuote()
        }
    }
    var quotesArr: [QuoteCore] = []
    
    var networkQuotesArr: [QuoteGardenQuoteVM] = []
    var authorImageURL: URL?
    var authorName: String?
    
    var quoteVM: QuoteGardenQuoteVM?
    
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
        configIdeaButton()
    }

    private func configIdeaButton() {
        switch state {
        case .network:
            quotesOfAuthorView.ideaButton.addTarget(self,
                                                    action: #selector(onIdeaButton(sender:)),
                                                    for: .touchUpInside)
        case .coreData:
            quotesOfAuthorView.ideaButton.addTarget(self,
                                                    action: #selector(onDeleteButton(sender:)),
                                                    for: .touchUpInside)
        }
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
            guard let name = authorName else { return }
            if authorImageURL == nil {
                quotesOfAuthorView.mainImageView.contentMode = .scaleAspectFit
                quotesOfAuthorView.mainImageView.image = UIImage(named: "unknown")
                
            }
            else {
                quotesOfAuthorView.mainImageView.contentMode = .scaleAspectFill
                quotesOfAuthorView.mainImageView.kf.setImage(with: authorImageURL)
            }
            quotesOfAuthorView.titleOfAuthor.text = name
            quotesOfAuthorView.quoteTextView.text = networkQuotesArr[currentQuoteIndex].content
            
            if networkQuotesArr.count > 1 {
                print("more than 1 qoute network")
                quotesOfAuthorView.nextButton.isButtonEnabled = true
            }
            
        case .coreData:
            guard let author = author else {
                return
            }
            if author.image.pngData() == UIImage(named: "unknown")?.pngData() {
                quotesOfAuthorView.mainImageView.contentMode = .scaleAspectFit
            }
            else {
                quotesOfAuthorView.mainImageView.contentMode = .scaleAspectFill
            }
            quotesOfAuthorView.titleOfAuthor.text = author.name
            quotesOfAuthorView.mainImageView.image = author.image
            quotesArr = author.quotes
            quotesOfAuthorView.quoteTextView.text = quotesArr[currentQuoteIndex].content
            if quotesArr.count > 1 {
                print("more than 1 qoute core")
                quotesOfAuthorView.nextButton.isButtonEnabled = true
            }
        }
    }
    
    private func updateQuote() {
        switch state {
        case .network:
            quotesOfAuthorView.quoteTextView.text = networkQuotesArr[currentQuoteIndex].content
            quotesOfAuthorView.nextButton.isButtonEnabled = !(currentQuoteIndex == networkQuotesArr.count - 1)
            if currentQuoteIndex == networkQuotesArr.count - 1 {
                quotesOfAuthorView.nextButton.isButtonEnabled = false
            }
            if currentQuoteIndex > 0 {
                quotesOfAuthorView.prevButton.isButtonEnabled = true
            }
            if currentQuoteIndex == 0 {
                quotesOfAuthorView.prevButton.isButtonEnabled = false
            }
        case .coreData:
            quotesOfAuthorView.quoteTextView.text = quotesArr[currentQuoteIndex].content
            if currentQuoteIndex == quotesArr.count - 1 {
                quotesOfAuthorView.nextButton.isButtonEnabled = false
            }
            if currentQuoteIndex > 0 {
                quotesOfAuthorView.prevButton.isButtonEnabled = true
            }
            if currentQuoteIndex == 0 {
                quotesOfAuthorView.prevButton.isButtonEnabled = false
            }
        }
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
    }
    
    @objc func onIdeaButton(sender: UIButton) {
        guard let authorName = authorName else {
            return
        }
        guard let quoteVM = quoteVM else {
            return
        }
        ImageManager.getAuthorImageURLUsingSlug(slug: convertAuthorName(name: authorName)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tuple):
                do {
                    let data = try Data(contentsOf: tuple.0)
                    if let image = UIImage(data: data) {
                        if self.quotesOfAuthorView.ideaButton.state == .selected {
                            self.quotesOfAuthorView.ideaButton.isSelected = false
                            CoreDataManager.removePair(quoteVM: quoteVM)
                            collectionViewUpdateSubject.send {}
                        }
                        else if self.quotesOfAuthorView.ideaButton.state == .normal {
                            self.quotesOfAuthorView.ideaButton.isSelected = true
                            if tuple.1 == .nature {
                                CoreDataManager.addPair(quoteVM: quoteVM, authorImageData: UIImage(named: "unknown")!.pngData())
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
    
    @objc func onDeleteButton(sender: UIButton) {
        guard let author = author else {
            return
        }
        let quoteVm = QuoteGardenQuoteVM(rootModel: QuoteGardenQuoteModel(quoteText: quotesArr[currentQuoteIndex].content, quoteAuthor: author.name))
        CoreDataManager.removePair(quoteVM: quoteVm)
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
