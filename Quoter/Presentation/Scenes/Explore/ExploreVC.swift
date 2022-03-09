//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import SnapKit
import AnimatedCollectionViewLayout
import Combine

protocol PresenterToExploreVCProtocol: AnyObject {
    var interactor: VCToExploreInteractorProtocol? { get set }
    
    func startAnimating()
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?], indexPaths: [IndexPath])
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath])
    func requestedNewData(edges: (Int, Int), offsetOfPage: Int)
}

class ExploreVC: MonitoredVC {
    
    var interactor: VCToExploreInteractorProtocol?
    var router: ExploreRouterProtocol?

    var tapOnBookGesture: UITapGestureRecognizer {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnBook(sender:)))
        return tapOnGesture
    }
    var tapOnFilterGesture: UITapGestureRecognizer {
        let tapOnGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(didTapOnFilter(sender:)))
        return tapOnGesture
    }

    lazy var exploreView: ExploreView = {
        let view = ExploreView(frame: view.bounds)
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func loadView() {
        super.loadView()
        view = exploreView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        exploreView.startAnimating()
        interactor?.requestDisplayInitialData()
        configCollectionView()
    }
    
    private func setup() {
        let vc = self
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        let router = ExploreRouter()
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        router.vc = vc
    }
    
    private func configCollectionView() {
        exploreView.collectionView.dataSource = self
        exploreView.collectionView.delegate = self
        exploreView.collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if exploreView.lottieAnimation != nil {
            connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))
        }
        else {
            if !interactor!.isDataLoaded {
                exploreView.startAnimating()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if exploreView.lottieAnimation != nil {
            exploreView.stopLottieAnimation()
            exploreView.lottieAnimation = nil
        }
    }
    
    @objc func didTapOnBook(sender: UITapGestureRecognizer) {
        router?.routeToModalAlertVC(quoteVM: interactor!.loadedVMs[interactor!.currentPage])
    }
    
    @objc func didTapOnFilter(sender: UITapGestureRecognizer) {
        router?.routeToFilters()
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor!.loadedVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? QuoteCell
        cell?.quoteVM = interactor!.loadedVMs[indexPath.item]
        cell?.mainImage = interactor!.loadedImages[indexPath.item]
        cell?.tapOnBookGesture = tapOnBookGesture
        cell?.tapOnFilterGesture = tapOnFilterGesture
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        Sound.windTransition2.play(extensionString: .mp3)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        interactor!.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        interactor?.requestNewData(edges: (4, 14), offsetOfPage: 5)
        interactor?.requestNewData(edges: (0, 10), offsetOfPage: 1)
        if interactor!.currentPage == interactor!.loadedVMs.count - 1 && interactor!.isLoadNewDataFunctionRunning {
            router?.routeToLoadingAlertVC()
        }
    }
}

extension ExploreVC: PresenterToExploreVCProtocol {

    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath]) {
        
        interactor!.loadedVMs.append(contentsOf: loadedVMs)
        interactor!.loadedImages.append(contentsOf: loadedImages)
        self.exploreView.collectionView.insertItems(at: indexPaths)
        self.exploreView.collectionView.isUserInteractionEnabled = true
        interactor!.isLoadNewDataFunctionRunning = false
        
        self.dismiss(animated: false)
    }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM],
                            loadedImages: [UIImage?],
                            indexPaths: [IndexPath]) {
        
        interactor!.currentPage = 0
        interactor!.capturedCurrentPage = 0
        interactor!.loadedVMs = loadedVMs
        interactor!.loadedImages = loadedImages
        self.exploreView.collectionView.insertItems(at: indexPaths)
        if self.exploreView.lottieAnimation != nil {
            self.exploreView.stopLottieAnimation()
        }
        interactor!.isDataLoaded = true
    }
    
    func requestedNewData(edges: (Int, Int), offsetOfPage: Int) {
        if interactor!.currentPage == interactor!.loadedVMs.count - offsetOfPage && !interactor!.isLoadNewDataFunctionRunning {
            interactor!.capturedCurrentPage = interactor!.currentPage
            if !interactor!.isLoadNewDataFunctionRunning {
                interactor!.isLoadNewDataFunctionRunning = true
                interactor?.requestDisplayNewData(genres: interactor!.selectedFilters, currentVMs: interactor!.loadedVMs, capturedPage: interactor!.capturedCurrentPage, edges: edges)
            }
        }
    }
    
    func startAnimating() {
        exploreView.collectionView.reloadData()
        exploreView.startAnimating()
    }
}
