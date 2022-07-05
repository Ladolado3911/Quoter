//
//  ExploreInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit
import SDWebImage
import Photos

enum ExploreDirection {
    case left
    case right
}

protocol ExploreInteractorProtocol {
    var presenter: ExplorePresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var loadedQuotes: [ExploreQuoteProtocol]? { get set }
    var currentPage: Int { get set }
    var currentGenre: Genre { get set }
    var websocketTask: URLSessionWebSocketTask? { get set }
    var timer: Timer? { get set }
    var isConfigurationRunning: Bool { get set }
    
    var scrollBeginOffset: CGPoint { get set }
    var scrollDidEndOffset: CGPoint { get set }
    
    //func buttonAnimationTimerFire(collectionView: UICollectionView?)
    func onDownloadButton()
    func presentAlert(title: String, text: String, mainButtonText: String, mainButtonStyle: UIAlertAction.Style, action: (() -> Void)?)
    
    func ping()
    func close()
    func send(genre: Genre)
    func receive() async throws -> QuoteModel?
    
    //MARK: Collection View methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    //func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
    
    //MARK: Scroll View methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scroll(direction: ExploreDirection)
}

class ExploreInteractor: ExploreInteractorProtocol {
    
    var presenter: ExplorePresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
    var loadedQuotes: [ExploreQuoteProtocol]? = [ExploreQuote(), ExploreQuote(), ExploreQuote(), ExploreQuote(), ExploreQuote()]
    var currentPage: Int = 0 {
        didSet {
//            print(currentPage)
//            print(loadedQuotes?.count ?? 0)
        }
    }
    var currentGenre: Genre = .general {
        didSet {
            SDWebImageDownloader.shared.cancelAllDownloads()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.loadedQuotes = [ExploreQuote(), ExploreQuote(), ExploreQuote(), ExploreQuote(), ExploreQuote()]
                print("cancel all downloads")
                self.currentPage = 0
                self.presenter?.reloadCollectionView()
            }
        }
    }
    var websocketTask: URLSessionWebSocketTask?
    var timer: Timer?
    
    var scrollBeginOffset: CGPoint = .zero
    var scrollDidEndOffset: CGPoint = .zero
    
    var isConfigurationRunning = false

    func onDownloadButton() {
        if let loadedQuotes = loadedQuotes {
            let quote = loadedQuotes[currentPage]
            let isAllowed = quote.isScreenshotAllowed
            if isAllowed {
                // vc saves image
                if PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized {
                    presenter?.screenShot()
                }
                else {
                    presenter?.presentAlert(title: "Alert",
                                            text: "Acces to photos is denied",
                                            mainButtonText: "Ok",
                                            mainButtonStyle: .default,
                                            action: nil)
                }
            }
            else {
                // vc presents alert
                presenter?.presentAlert(title: "Alert",
                                        text: "Image is not yet loaded",
                                        mainButtonText: "Ok",
                                        mainButtonStyle: .default,
                                        action: nil)
            }
        }
        else {
            presenter?.presentAlert(title: "Alert",
                                    text: "Image is not yet loaded",
                                    mainButtonText: "Ok",
                                    mainButtonStyle: .default,
                                    action: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadedQuotes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display")
        if let cell = cell as? ExploreCell,
           let loadedQuotes = loadedQuotes {
            //let item = loadedQuotes[indexPath.item]
            cell.buildSubviews()
            cell.buildConstraints()
            
            if indexPath.item == currentPage {
                self.presenter?.turnInteractionOff()
            }
            //cell.startAnimating()
            let item = loadedQuotes[indexPath.item]
            
            if item.isLoading {
                cell.startAnimating()
            }
//            if !item.isLoading && cell.imgView.image == nil {
//                cell.startAnimating()
//
//                cell.imgView.sd_setImage(with: URL(string: item.quoteImageURLString ?? "")) {_,_,_,_ in
//
//                    cell.stopAnimating()
//                }
//            }

            Task.init(priority: .high) { [weak self] in
                guard let self = self else { return }
                var quote: ExploreQuoteProtocol = ExploreQuote()
                let item = loadedQuotes[indexPath.item]
                
                if !item.isLoading {
                    quote = item
                }
                else {
                    print("call")
                    
                    send(genre: currentGenre)
                    let quoteModel = try await receive()
                    //let quoteModel = try await exploreNetworkWorker?.getSmallQuote(genre: currentGenre)
                    let exploreAuthor = ExploreAuthor(idString: quoteModel!.author.id,
                                                      slug: quoteModel!.author.slug,
                                                      name: quoteModel!.author.name,
                                                      authorImageURLString: quoteModel!.author.authorImageURLString,
                                                      authorDesc: quoteModel!.author.authorDesc)
                    let exploreQuote = ExploreQuote(quoteImageURLString: quoteModel!.quoteImageURLString,
                                                    content: quoteModel!.content,
                                                    author: exploreAuthor)
                    quote = exploreQuote
                }
                await MainActor.run { [quote] in
                    //guard let self = self else { return }
                    if let author = quote.author,
                       let content = quote.content,
                       let imageURLString = quote.quoteImageURLString {
                        
                        // turn on interaction
                        if indexPath.item == currentPage {
                            self.presenter?.turnInteractionOn()
                        }
                        
                        self.loadedQuotes![indexPath.item] = quote
                        cell.authorNameLabel.text = author.name
                        cell.quoteContentLabel.text = quote.content
                        let fontSize = cell.getFontSizeForQuote(stringCount: CGFloat(content.count))
                        cell.quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: fontSize)
                        self.loadedQuotes![indexPath.item].isLoading = false
                        cell.imgView.sd_setImage(with: URL(string: imageURLString),
                                                 placeholderImage: nil,
                                                 options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed, .refreshCached]) { _, error, _, _ in
                            if let error = error {
                                print("sd web error: \(error.localizedDescription)")
                                cell.stopAnimating()
                                //cell.stopAnimating()
                            }
                            else {
                                cell.stopAnimating()
                                self.loadedQuotes![indexPath.item].isScreenshotAllowed = true
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UIScreen.main.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //let prevPage = currentPage
        //var contentOffsetX: CGFloat
        var shouldAddCell: Bool = false
        if scrollDidEndOffset.x > scrollBeginOffset.x {
            //contentOffsetX = Constants.screenWidth
            currentPage += 1
            print(currentPage)
            print(loadedQuotes?.count ?? 0)
            shouldAddCell = currentPage >= (loadedQuotes?.count ?? 0) - 4
            if currentPage >= (loadedQuotes?.count ?? 0) - 4 {
                loadedQuotes?.append(ExploreQuote())
            }
        }
        else {
            //contentOffsetX = -Constants.screenWidth
            currentPage -= 1
        }
        //currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.addCellWhenSwiping(indexPaths: indexPaths, shouldAddCell: shouldAddCell)
    }
    
    func scroll(direction: ExploreDirection) {
        var contentOffsetX: CGFloat? = nil
        var shouldAddCell: Bool = false
        //let prevPage = currentPage
        switch direction {
        case .left:
            if currentPage - 1 < 0 {
                presenter?.turnLeftArrowOn()
                return
            }
            currentPage -= 1
            contentOffsetX = -Constants.screenWidth
        case .right:
            currentPage += 1
            contentOffsetX = Constants.screenWidth
            print(currentPage)
            print(loadedQuotes?.count ?? 0)
            shouldAddCell = currentPage >= (loadedQuotes?.count ?? 0) - 4
            if currentPage >= (loadedQuotes?.count ?? 0) - 4 {
                loadedQuotes?.append(ExploreQuote())
            }
        }
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.scroll(direction: direction, contentOffsetX: contentOffsetX!, indexPaths: indexPaths, shouldAddCell: shouldAddCell)
    }
    
    func presentAlert(title: String, text: String, mainButtonText: String, mainButtonStyle: UIAlertAction.Style, action: (() -> Void)?) {
        presenter?.presentAlert(title: title,
                                text: text,
                                mainButtonText: mainButtonText,
                                mainButtonStyle: mainButtonStyle,
                                action: action)
    }
    
    func ping() {
        websocketTask?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    func close() {
        websocketTask?.cancel()
    }
    
    func send(genre: Genre) {
        websocketTask?.send(.string("\(genre.rawValue)"), completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    func receive() async throws -> QuoteModel? {
        let message = try await websocketTask?.receive()
        switch message {
        case .data(let data):
            let decoded = try JSONDecoder().decode(QuoteModel.self, from: data)
            print("content is \(decoded.content)")
            return decoded
        case .string(let str):
            print("string in \(str)")
            return nil
        @unknown default:
            return nil
            //break
        }
    
    }
}

