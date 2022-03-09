//
//  QoaInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/6/22.
//

import UIKit

protocol VCToQoaInteractorProtocol {
    var presenter: InteractorToQoaPresenterProtocol? { get set }
    
    var networkQuotesArr: [QuoteGardenQuoteVM] { get set }
    var state: QuotesOfAuthorVCState { get set }
    var networkAuthorImage: UIImage? { get set }
    var authorName: String? { get set }
    var author: AuthorCoreVM? { get set }
    
    var authorsVCreloadDataClosure: (() -> Void)? { get set }
    
    func requestToDisplayInitialData()
    
    func requestToDisplayUpdatedData(state: QuotesOfAuthorVCState, networkQuotesArr: [QuoteGardenQuoteVM], currentQuoteIndex: Int, quotesArr: [QuoteCore])
    func requestToChangeIdeaState(isSwitchButtonSelected: Bool)
    func requestToconfigViewButtons()
    func requestToDismissView()
    func requestToDelete()
    func onNext()
    func onPrev()
}

class QoaInteractor: VCToQoaInteractorProtocol {
    var presenter: InteractorToQoaPresenterProtocol?
    
    let networkSetWorker = QoaNetworkSetWorker()
    let coreSetWorker = QoaCoreSetWorker()
    
    var authorsVCreloadDataClosure: (() -> Void)?
    
    let defaultImage = UIImage(named: "testUpperQuotism")
    var state: QuotesOfAuthorVCState = .coreData {
        didSet {
            presenter?.updateViewState(state: state)
        }
    }
    var author: AuthorCoreVM?
    var currentQuoteIndex: Int = 0 {
        didSet {
            requestToDisplayUpdatedData(state: state,
                                        networkQuotesArr: networkQuotesArr,
                                        currentQuoteIndex: currentQuoteIndex,
                                        quotesArr: quotesArr)
        }
    }
    var quotesArr: [QuoteCore] = []
    
    var networkQuotesArr: [QuoteGardenQuoteVM] = []
    var authorImageURL: URL?
    var networkAuthorImage: UIImage?
    var authorName: String?
    
    var quoteVM: QuoteGardenQuoteVM?
    
    func requestToDisplayInitialData() {
        
        switch state {
        case .network:
            guard let name = authorName else { return }
            let content = networkSetWorker.getInitialContent(defaultImage: defaultImage,
                                                      networkAuthorImage: networkAuthorImage,
                                                      networkArray: networkQuotesArr)
            presenter?.formatNetworkInitialData(name: name,
                                         contentMode: content.contentMode,
                                         exportImage: content.exportImage,
                                         array: networkQuotesArr,
                                         currentIndex: currentQuoteIndex,
                                         isButtonEnabled: content.isButtonEnabled)
            
        case .coreData:
            guard let author = author else { return }
            let content = coreSetWorker.getInitialContent(author: author, defaultImage: defaultImage)
            quotesArr = author.quotes
            presenter?.formatCoreInitialData(author: author,
                                      contentMode: content.contentMode,
                                      isButtonEnabled: content.isButtonEnabled,
                                      currentIndex: currentQuoteIndex,
                                      array: quotesArr)
        }
    }
    
    func requestToDisplayUpdatedData(state: QuotesOfAuthorVCState, networkQuotesArr: [QuoteGardenQuoteVM], currentQuoteIndex: Int, quotesArr: [QuoteCore]) {
        switch state {
        case .network:
            let quoteVM = networkQuotesArr[currentQuoteIndex]
            let quoteContent = quoteVM.content
            let content = networkSetWorker.getUpdatedContent(currentQuoteIndex: currentQuoteIndex, networkQuotesArr: networkQuotesArr)
            let isIdeaButtonSelected = CoreDataWorker.isQuoteInCoreData(quoteVM: quoteVM)
            presenter?.formatNetworkUpdatedData(content: content, isIdeaButtonEnabled: isIdeaButtonSelected, quoteContent: quoteContent)
        case .coreData:
            let content = coreSetWorker.getUpdatedContent(currentQuoteIndex: currentQuoteIndex, quotesArr: quotesArr, networkArr: networkQuotesArr)
            presenter?.formatCoreUpdatedData(content: content, quotesArr: quotesArr, currentQuoteIndex: currentQuoteIndex)
        }
    }
    
    func requestToChangeIdeaState(isSwitchButtonSelected: Bool) {
        let quoteVMM = networkQuotesArr[currentQuoteIndex]
        let image: UIImage? = networkAuthorImage == nil ? defaultImage : networkAuthorImage
        if let image = image {
            if isSwitchButtonSelected {
                CoreDataWorker.removePair(quoteVM: quoteVMM)
            }
            else {
                Sound.idea.play(extensionString: .mp3)
                CoreDataWorker.addPair(quoteVM: quoteVMM, authorImageData: image.pngData())
            }
            collectionViewUpdateSubject.send {}
            presenter?.formatIdeaChange()
        }
        else {
            print("Could not unwrap")
        }
    }
    
    func requestToDelete() {
        guard let author = author else {
            return
        }
        let quoteVm = QuoteGardenQuoteVM(rootModel: QuoteGardenQuoteModel(quoteText: quotesArr[currentQuoteIndex].content, quoteAuthor: author.name))
        
        CoreDataWorker.removePair(quoteVM: quoteVm) { [weak self] in
            guard let self = self else { return }
            if self.quotesArr.count == 1 {
                if let authorsVCreloadDataClosure = self.authorsVCreloadDataClosure {
                    self.presenter?.dismissView {
                        authorsVCreloadDataClosure()
                    }
                }
                return
            }
            switch self.currentQuoteIndex {
            case self.quotesArr.count - 1:
                self.quotesArr.removeLast()
                self.currentQuoteIndex -= 1
            case 0:
                self.quotesArr.removeFirst()
                self.requestToDisplayUpdatedData(state: self.state,
                                                 networkQuotesArr: self.networkQuotesArr,
                                                 currentQuoteIndex: self.currentQuoteIndex,
                                                 quotesArr: self.quotesArr)
            default:
                self.quotesArr.remove(at: self.currentQuoteIndex)
                self.currentQuoteIndex -= 1
            }
        }
    }
    
    func onNext() {
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
    
    func onPrev() {
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
    
    func requestToconfigViewButtons() {
        presenter?.configViewButtons()
    }
    
    func requestToDismissView() {
        presenter?.dismissView {
            
        }
    }
}
