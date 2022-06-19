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
    
    var loadedQuotes: [ExploreQuoteProtocol?]? { get set }
    var currentPage: Int { get set }
    var currentGenre: Genre { get set }
    var websocketTask: URLSessionWebSocketTask? { get set }
    var timer: Timer? { get set }
    
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
    
    var loadedQuotes: [ExploreQuoteProtocol?]? = [nil, nil, nil, nil, nil]
    var currentPage: Int = 0
    var currentGenre: Genre = .general {
        didSet {
            self.loadedQuotes = [nil, nil, nil, nil, nil]
            print("cancel all downloads")
            SDWebImageDownloader.shared.cancelAllDownloads()
            //currentPage = 0
            self.presenter?.reloadCollectionView()
        }
    }
    var websocketTask: URLSessionWebSocketTask?
    var timer: Timer?

    func onDownloadButton() {
        if let loadedQuotes = loadedQuotes,
           let quote = loadedQuotes[currentPage] {
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
        if let cell = cell as? ExploreCell {
            
            cell.startAnimating()
            cell.buildSubviews()
            cell.buildConstraints()
            Task.init(priority: .high) {
                var quote: ExploreQuoteProtocol
                if let arr = loadedQuotes,
                   let unwrapped = arr[indexPath.item] {
                    quote = unwrapped
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
                await MainActor.run { [weak self, quote] in
                    guard let self = self else { return }
                    loadedQuotes![indexPath.item] = quote
                    cell.authorNameLabel.text = quote.author.name
                    cell.quoteContentLabel.text = quote.content
                    let fontSize = cell.getFontSizeForQuote(stringCount: CGFloat(quote.content.count))
                    cell.quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: fontSize)
                    cell.imgView.sd_setImage(with: URL(string: quote.quoteImageURLString),
                                             placeholderImage: nil,
                                             options: [.continueInBackground, .highPriority, .scaleDownLargeImages, .retryFailed, .refreshCached]) { _, error, _, _ in
                        if let error = error {
                            print("sd web error: \(error.localizedDescription)")
                            cell.stopAnimating()
                        }
                        else {
                            cell.stopAnimating()
                            self.loadedQuotes![indexPath.item]?.isScreenshotAllowed = true
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
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        loadedQuotes?.append(nil)
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.addCellWhenSwiping(indexPaths: indexPaths)
    }
    
    func scroll(direction: ExploreDirection) {
        var contentOffsetX: CGFloat? = nil
        switch direction {
        case .left:
            if currentPage - 1 < 0 {
                return
            }
            currentPage -= 1
            contentOffsetX = -Constants.screenWidth
        case .right:
            currentPage += 1
            contentOffsetX = Constants.screenWidth
        }
        loadedQuotes?.append(nil)
        let indexPaths = [IndexPath(item: loadedQuotes!.count - 2, section: 0)]
        presenter?.scroll(direction: direction, contentOffsetX: contentOffsetX!, indexPaths: indexPaths)
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

