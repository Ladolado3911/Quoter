//
//  ExploreVCTemp.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

protocol ExploreVCProtocol {
    var interactor: ExploreInteractorProtocol? { get set }
    var router: ExploreRouterProtocol? { get set }
    var exploreView: ExploreView? { get set }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath])
    func addCellWhenSwiping(indexPaths: [IndexPath])
    func screenshot()
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: @escaping () -> Void)
}

class ExploreVC: UIViewController {
    
    var interactor: ExploreInteractorProtocol?
    weak var router: ExploreRouterProtocol?
    var exploreView: ExploreView?
    
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
    }
    
    private func setup() {
        let vc = self
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        let router = ExploreRouter()
        let exploreNetworkWorker = ExploreNetworkWorker()
        let exploreView = ExploreView(frame: UIScreen.main.bounds)
        vc.interactor = interactor
        vc.router = router
        vc.exploreView = exploreView
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
//        let isAllowed = interactor!.loadedQuotes![interactor!.currentPage]!.isScreenshotAllowed
//        if isAllowed {
//            if let exploreView = exploreView {
//                let screenShotView = ExploreScreenshotView(exploreCollectionView: exploreView.collectionView, frame: exploreView.bounds)
//                screenShotView.takeScreenshot()
//            }
//        }
//        else {
//            presentAlert(title: "Alert",
//                         text: "Image is not yet loaded",
//                         mainButtonText: "Ok",
//                         mainButtonStyle: .default) {
//                
//            }
//        }
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
    func displayInitialQuotes(exploreQuotes: [ExploreQuoteProtocol]) {
        interactor?.loadedQuotes = exploreQuotes
        print(exploreQuotes.count)
        exploreView?.collectionView.reloadData()
        //exploreView?.stopAnimating()
    }
    
    func displayNextQuotes(exploreQuotes: [ExploreQuoteProtocol]) {
        let lastIntIndex = interactor!.loadedQuotes!.count - 1
        let indexPaths = exploreQuotes.enumerated().map { IndexPath(item: lastIntIndex + $0.offset + 1, section: 0) }
        interactor?.loadedQuotes?.append(contentsOf: exploreQuotes)
        exploreView?.collectionView.insertItems(at: indexPaths)
    }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath]) {
        let nextOffset = CGPoint(x: exploreView!.collectionView.contentOffset.x + contentOffsetX,
                                 y: exploreView!.collectionView.contentOffset.y)
        exploreView?.collectionView.setContentOffset(nextOffset, animated: true)
        exploreView?.collectionView.insertItems(at: indexPaths)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
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
    
    func addCellWhenSwiping(indexPaths: [IndexPath]) {
        exploreView?.collectionView.insertItems(at: indexPaths)
    }
    
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: @escaping () -> Void) {
        presentAlert(title: title,
                     text: text,
                     mainButtonText: mainButtonText,
                     mainButtonStyle: mainButtonStyle,
                     mainButtonAction: action)
    }
    
    func screenshot() {
        if let exploreView = exploreView {
            let screenShotView = ExploreScreenshotView(exploreCollectionView: exploreView.collectionView, frame: exploreView.bounds)
            screenShotView.takeScreenshot()
        }
    }
}
