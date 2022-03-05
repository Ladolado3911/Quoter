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
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?], indexPaths: [IndexPath])
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath])
    func requestedNewData(edges: (Int, Int), offsetOfPage: Int)
}

class ExploreVC: MonitoredVC {
    
    var interactor: VCToExploreInteractorProtocol?
    var router: ExploreRouterProtocol?
    
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImages: [UIImage?] = []
    var selectedFilters: [String] = [""]
    var isLoadNewDataFunctionRunning: Bool = false
    var isDataLoaded = false
    
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
    var currentPage: Int = 0 {
        didSet {
            print(currentPage)
        }
    }
    var capturedCurrentPage: Int = 0
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
        interactor?.requestDisplayInitialData(genres: selectedFilters)
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
    
    func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        exploreView.collectionView.reloadData()
        exploreView.startAnimating()
        interactor?.requestDisplayInitialData(genres: selectedFilters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if exploreView.lottieAnimation != nil {
            connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))
        }
        else {
            if !isDataLoaded {
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
        router?.routeToModalAlertVC(quoteVM: loadedVMs[currentPage])
    }
    
    @objc func didTapOnFilter(sender: UITapGestureRecognizer) {
        router?.routeToFilters()
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadedVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? QuoteCell
        cell?.quoteVM = loadedVMs[indexPath.item]
        cell?.mainImage = loadedImages[indexPath.item]
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
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        interactor?.requestNewData(edges: (4, 14), offsetOfPage: 5)
        interactor?.requestNewData(edges: (0, 10), offsetOfPage: 1)
        if currentPage == self.loadedVMs.count - 1 && isLoadNewDataFunctionRunning {
            router?.routeToLoadingAlertVC()
        }
    }
}

extension ExploreVC: PresenterToExploreVCProtocol {

    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath]) {
        
        self.loadedVMs.append(contentsOf: loadedVMs)
        self.loadedImages.append(contentsOf: loadedImages)
        self.exploreView.collectionView.insertItems(at: indexPaths)
        self.exploreView.collectionView.isUserInteractionEnabled = true
        self.isLoadNewDataFunctionRunning = false
        
        self.dismiss(animated: false)
    }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM],
                            loadedImages: [UIImage?],
                            indexPaths: [IndexPath]) {
        
        self.currentPage = 0
        self.capturedCurrentPage = 0
        self.loadedVMs = loadedVMs
        self.loadedImages = loadedImages
        self.exploreView.collectionView.insertItems(at: indexPaths)
        if self.exploreView.lottieAnimation != nil {
            self.exploreView.stopLottieAnimation()
        }
        self.isDataLoaded = true
    }
    
    func requestedNewData(edges: (Int, Int), offsetOfPage: Int) {
        if currentPage == loadedVMs.count - offsetOfPage && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                interactor?.requestDisplayNewData(genres: selectedFilters, currentVMs: loadedVMs, capturedPage: capturedCurrentPage, edges: edges)
            }
        }
    }
}
