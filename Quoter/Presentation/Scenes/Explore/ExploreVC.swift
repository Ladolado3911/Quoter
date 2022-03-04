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

protocol PresenterToVCProtocol: AnyObject {
    var interactor: VCToInteractorProtocol? { get set }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?], indexPaths: [IndexPath])
    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath])
}

class ExploreVC: MonitoredVC {
    
//    var router: ExploreRouter?
    var interactor: VCToInteractorProtocol?
    var router: ExploreRouterProtocol?
    
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImages: [UIImage?] = []
    var selectedFilters: [String] = [""]
    var isLoadNewDataFunctionRunning: Bool = false
    var isDataLoaded = false
    
    lazy var presentQuotesOfAuthorClosure: (([QuoteGardenQuoteVM], UIImage?, QuoteGardenQuoteVM)) -> Void = { [weak self] quoteVMs in
        guard let self = self else { return }
        let destVC = QuotesOfAuthorVC()
        destVC.modalTransitionStyle = .coverVertical
        destVC.modalPresentationStyle = .overCurrentContext
        destVC.networkQuotesArr = quoteVMs.0
        destVC.state = .network
        destVC.networkAuthorImage = quoteVMs.1
       // destVC.authorImageURL = quoteVMs.1
        destVC.authorName = self.loadedVMs[self.currentPage].authorName
        destVC.quoteVM = quoteVMs.2
        self.present(destVC, animated: true)
    }
    
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

    lazy var collectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()

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
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
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
    
    func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        collectionView.reloadData()
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
        let modalAlertVC = ModalAlertVC()
        let quoteVM = loadedVMs[currentPage]
        modalAlertVC.modalTransitionStyle = .crossDissolve
        modalAlertVC.modalPresentationStyle = .custom
        modalAlertVC.authorName = quoteVM.authorName
        modalAlertVC.presentingClosure = presentQuotesOfAuthorClosure
        modalAlertVC.quoteVM = quoteVM
        present(modalAlertVC, animated: false)
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
        if currentPage == self.loadedVMs.count - 5 && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                interactor?.requestDisplayNewData(genres: selectedFilters, currentVMs: self.loadedVMs, capturedPage: self.capturedCurrentPage, edges: (4, 14))
            }
        }
        if currentPage == self.loadedVMs.count - 1 && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                interactor?.requestDisplayNewData(genres: selectedFilters, currentVMs: self.loadedVMs, capturedPage: self.capturedCurrentPage, edges: (0, 10))
            }
        }
        if currentPage == self.loadedVMs.count - 1 && isLoadNewDataFunctionRunning {
            let loadingAlertVC = LoadingAlertVC()
            loadingAlertVC.modalTransitionStyle = .crossDissolve
            loadingAlertVC.modalPresentationStyle = .custom
            present(loadingAlertVC, animated: false)
        }
    }
}

extension ExploreVC: PresenterToVCProtocol {

    func displayNewData(loadedVMs: [QuoteGardenQuoteVM],
                        loadedImages: [UIImage?],
                        indexPaths: [IndexPath]) {
        
        self.loadedVMs.append(contentsOf: loadedVMs)
        self.loadedImages.append(contentsOf: loadedImages)
        self.collectionView.insertItems(at: indexPaths)
        self.collectionView.isUserInteractionEnabled = true
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
        self.collectionView.insertItems(at: indexPaths)
        if self.exploreView.lottieAnimation != nil {
            self.exploreView.stopLottieAnimation()
        }
        self.isDataLoaded = true
    }
}
