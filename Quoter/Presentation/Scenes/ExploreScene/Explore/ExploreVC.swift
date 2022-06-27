//
//  ExploreVCTemp.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

protocol ExploreVCProtocol: AnyObject, FilterToExploreProtocol {
    var interactor: ExploreInteractorProtocol? { get set }
    var router: ExploreRouterProtocol? { get set }
    var exploreView: ExploreView? { get set }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath], shouldAddCell: Bool)
    func addCellWhenSwiping(indexPaths: [IndexPath], shouldAddCell: Bool)
    func screenshot()
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: (() -> Void)?)
    func reloadCollectionView()
    func present(vc: UIViewController, animated: Bool)
    func turnLeftArrowOn()
    
    func turnInteractionOn()
    func turnInteractionOff()
}

class ExploreVC: UIViewController {
    
    var interactor: ExploreInteractorProtocol?
    var router: ExploreRouterProtocol?
    var exploreView: ExploreView?

    lazy var quoteButtonTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onQuoteButton(sender:)))
        return gesture
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configButtons()
        configWebsocket()
        configTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exploreView?.collectionView.visibleCells.forEach({ cell in
            if let cell = cell as? ExploreCell {
                cell.stopAnimating()
            }
        })
    }

    private func configCollectionView() {
        view = self.exploreView
        exploreView?.collectionView.prefetchDataSource = self
        exploreView?.collectionView.dataSource = self
        exploreView?.collectionView.delegate = self
        exploreView?.collectionView.register(ExploreCell.self, forCellWithReuseIdentifier: "ExploreCell")
    }
    
    private func configButtons() {
        exploreView?.leftArrowButton.addTarget(self, action: #selector(scrollLeft), for: .touchUpInside)
        exploreView?.rightArrowButton.addTarget(self, action: #selector(scrollRight), for: .touchUpInside)
        exploreView?.downloadQuotePictureButton.addTarget(self, action: #selector(onDownloadButton), for: .touchUpInside)
        exploreView?.filterButton.addTarget(self, action: #selector(onFilterButton), for: .touchUpInside)
        exploreView?.quoteButtonView.addGestureRecognizer(quoteButtonTapGesture)
    }
    
    private func configWebsocket() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://quotie-quoter-api.herokuapp.com/getSmallQuote")
        interactor?.websocketTask = session.webSocketTask(with: url!)
        interactor?.websocketTask?.resume()
        interactor?.isConfigurationRunning = true
    }
    
    private func configTimer() {
        interactor?.timer = Timer.scheduledTimer(timeInterval: 5,
                                                 target: self,
                                                 selector: #selector(buttonAnimationTimerFire(sender:)),
                                                 userInfo: nil,
                                                 repeats: true)
    }
    
    private func setup() {
        let vc = self
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        let router = ExploreRouter()
        let exploreNetworkWorker = ExploreNetworkWorker()
        let exploreView = ExploreView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.exploreView = exploreView
        vc.router = router
        interactor.presenter = presenter
        interactor.exploreNetworkWorker = exploreNetworkWorker
        presenter.vc = vc
        router.vc = vc
    }
}

extension ExploreVC {
    @objc func scrollLeft(sender: ArrowButton) {
        exploreView?.collectionView.isUserInteractionEnabled = false
        exploreView?.leftArrowButton.isEnabled = false
        interactor?.scroll(direction: .left)
    }
    
    @objc func scrollRight(sender: ArrowButton) {
        exploreView?.collectionView.isUserInteractionEnabled = false
        exploreView?.rightArrowButton.isEnabled = false
        interactor?.scroll(direction: .right)
    }
    
    @objc func onDownloadButton(sender: UIButton) {
        interactor?.onDownloadButton()
    }
    
    @objc func onFilterButton(sender: UIButton) {
        router?.routeToFilterVC(with: interactor?.currentGenre ?? .general)
    }
    
    @objc func onQuoteButton(sender: UIButton) {
        let quote = interactor!.loadedQuotes![interactor!.currentPage]
        if quote.isLoading {
            presentAlert(title: "Alert",
                         text: "Content is still loading",
                         mainButtonText: "Ok",
                         mainButtonStyle: .cancel,
                         action: nil)
        }
        else {
            router?.routeToAuthorVC(authorID: quote.author!.idString,
                                    authorName: quote.author!.name,
                                    authorImageURLString: quote.author!.authorImageURLString,
                                    authorDesc: quote.author!.authorDesc)
        }
    }
    
    @objc func buttonAnimationTimerFire(sender: Timer) {
        //interactor?.buttonAnimationTimerFire(collectionView: exploreView?.collectionView)
        exploreView?.animateQuoteButton()
        exploreView?.animateFilterButton()
        interactor?.websocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
            if let error = error {
                guard let self = self else { return }
                if !self.interactor!.isConfigurationRunning {
                    self.configWebsocket()
                }
                print("pong error is \(error.localizedDescription)")
            }
        })
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        interactor?.collectionView(collectionView, cellForItemAt: indexPath) ?? ExploreCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        interactor?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //interactor?.collectionView(collectionView, prefetchItemsAt: indexPaths)
        print("prefetch at \(indexPaths.map { $0.item })")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        interactor?.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset)
    }
}

extension ExploreVC: ExploreVCProtocol {

    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath], shouldAddCell: Bool) {
        let nextOffset = CGPoint(x: exploreView!.collectionView.contentOffset.x + contentOffsetX,
                                 y: exploreView!.collectionView.contentOffset.y)
        if direction == .right {
            
            if shouldAddCell {
                exploreView?.collectionView.insertItems(at: indexPaths)
                //exploreView?.collectionView.reloadItems(at: indexPaths)
                print("adding cell")
            }
        }
        exploreView?.collectionView.setContentOffset(nextOffset, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            switch direction {
            case .left:
                self.exploreView?.collectionView.isUserInteractionEnabled = true
                self.exploreView?.leftArrowButton.isEnabled = true
            case .right:
                self.exploreView?.collectionView.isUserInteractionEnabled = true
                self.exploreView?.rightArrowButton.isEnabled = true
            }
        }
    }
    
    func turnInteractionOn() {
        self.exploreView?.collectionView.isUserInteractionEnabled = true
        self.exploreView?.leftArrowButton.isEnabled = true
        self.exploreView?.rightArrowButton.isEnabled = true
    }
    
    func turnInteractionOff() {
        self.exploreView?.collectionView.isUserInteractionEnabled = false
        self.exploreView?.leftArrowButton.isEnabled = false
        self.exploreView?.rightArrowButton.isEnabled = false
    }
    
    func addCellWhenSwiping(indexPaths: [IndexPath], shouldAddCell: Bool) {
        if shouldAddCell {
            exploreView?.collectionView.insertItems(at: indexPaths)
        }
    }
    
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: (() -> Void)?) {
        var newAction: () -> Void
        if let action = action {
            newAction = action
        }
        else {
            newAction = { }
        }
        presentAlert(title: title,
                     text: text,
                     mainButtonText: mainButtonText,
                     mainButtonStyle: mainButtonStyle,
                     mainButtonAction: newAction)
    }
    
    func screenshot() {
        if let exploreView = exploreView,
           let exploreCell = exploreView.collectionView.cellForItem(at: IndexPath(item: interactor!.currentPage, section: 0)) as? ExploreCell {
            let newCell = ExploreScreenshotCell(exploreCell: exploreCell, frame: exploreCell.bounds)
            newCell.takeScreenshot { [weak self] in
                guard let self = self else { return }
                self.interactor?.presentAlert(title: "Alert",
                                              text: "Image saved successfully",
                                              mainButtonText: "Ok",
                                              mainButtonStyle: .default,
                                              action: nil)
            }
        }
    }
    
    func reloadCollectionView() {
        exploreView?.collectionView.reloadData()
        exploreView?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        UIView.animate(withDuration: 1, delay: 1.5) { [weak self] in
            guard let self = self else { return }
            self.exploreView?.collectionView.alpha = 1
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.exploreView?.collectionView.isUserInteractionEnabled = true
                self.exploreView?.rightArrowButton.isEnabled = true
                self.exploreView?.leftArrowButton.isEnabled = true
            }
        }
    }
    
    func present(vc: UIViewController, animated: Bool) {
        present(vc, animated: animated)
    }
    
    func turnLeftArrowOn() {
        self.exploreView?.leftArrowButton.isEnabled = true
    }
}

extension ExploreVC: FilterToExploreProtocol {
    func sendBackGenre(genre: Genre) {
        exploreView?.collectionView.isUserInteractionEnabled = false
        exploreView?.rightArrowButton.isEnabled = false
        exploreView?.leftArrowButton.isEnabled = false
        exploreView?.filterButton.setTitle(genre.rawValue.capitalized, for: .normal)
        exploreView?.stopAnimating()
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.exploreView?.collectionView.alpha = 0
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                
                self.interactor?.currentGenre = genre
            }
        }
    }
}

extension ExploreVC: URLSessionWebSocketDelegate {

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("did connect to socket")
        interactor?.isConfigurationRunning = false
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("did lose connection with socket")
    }
}

