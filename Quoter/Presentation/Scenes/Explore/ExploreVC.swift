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

enum ScrollingDirection {
    case left
    case right
}

protocol PresenterToVCProtocol: AnyObject {
    var interactor: VCToInteractorProtocol? { get set }
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?])
    
}

class ExploreVC: MonitoredVC {
    
//    var router: ExploreRouter?
    var interactor: VCToInteractorProtocol?
    
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImageURLs: [URL?] = []
    var loadedImages: [UIImage?] = []
    
    var isAdditionalDataAdded = true
    
    var selectedFilters: [String] = []
    
    var scrollingDirection: ScrollingDirection = .right
    
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
    
    
    
    var currentGenre: String = ""

    var currentIndex: Int = 0
    var currentX: CGFloat = 0
    var prevX: CGFloat = -1
    
    var tempQuoteVM: QuoteVM?
    
    var currentNetworkPage: Int = 0
    var totalNetworkPages: Int = 0

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

    let animationFrame: CGRect = {
        let size = PublicConstants.screenWidth / 3
        let x = PublicConstants.screenWidth / 2 - (size / 2)
        let y = PublicConstants.screenHeight / 2 - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        return frame
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
        //print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
        exploreView.startAnimating()
        interactor?.displayInitialData()
//        self.loadInitialData {
////                lottieView.stopLottieAnimation()
//        }
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    private func setup() {
        let vc = self
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        //let router = ExploreRouter()
        vc.interactor = interactor
        //vc.router = router
        interactor.presenter = presenter
        presenter.vc = vc
        
        
    }
    
    private func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        currentPage = 0
        capturedCurrentPage = 0
        collectionView.reloadData()

        exploreView.startAnimating()
    
        loadImages { [weak self] in
            guard let self = self else { return }
            self.load10RandomQuotes {
                self.exploreView.stopLottieAnimation()
                self.collectionView.reloadData()
                self.isDataLoaded = true
            }
        }
    }

    private func loadInitialData(completion: @escaping () -> Void) {
        loadImages { [weak self] in
            guard let self = self else { return }
            self.load10RandomQuotes {
                self.collectionView.insertItems(at: self.loadedVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) })
                if self.exploreView.lottieAnimation != nil {
                    self.exploreView.stopLottieAnimation()
                }
                self.isDataLoaded = true
            }
        }
    }
    
    private func loadNewData(edges: (Int, Int), completion: @escaping () -> Void) {
        loadImages { [weak self] in
            guard let self = self else { return }
            self.load10RandomQuotes {
                let indexPaths = self.loadedVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
                self.collectionView.insertItems(at: Array(indexPaths[(self.capturedCurrentPage + edges.0)...self.capturedCurrentPage + edges.1]))
                self.collectionView.isUserInteractionEnabled = true
                self.isLoadNewDataFunctionRunning = false
                self.dismiss(animated: false)
            }
        }
    }
    
    private func load10RandomQuotes(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for _ in 0..<10 {
            group.enter()
            loadRandomQuote(genre: selectedFilters.randomElement() ?? "") {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))

        if exploreView.lottieAnimation != nil {
//                lottieView.stopLottieAnimation()
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
    
    private func startWifiAnimation() {
        exploreView.createAndStartLottieAnimation(animation: .wifiOff,
                                                 animationSpeed: 2,
                                                 frame: animationFrame,
                                                 loopMode: .autoReverse,
                                                 contentMode: .scaleAspectFit)
    }
    
    private func loadRandomQuote(genre: String, completion: @escaping () -> Void) {
        QuoteGardenManager.getRandomQuote(genre: genre) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quote):
                self.loadedVMs.append(quote)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImages(completion: @escaping () -> Void) {
        ImageManager.load10LandscapeURLs { [weak self] result in
            switch result {
            case .success(let urls):
                let shuffled = urls.shuffled().compactMap { $0 }
                let imageFetchingQueue = DispatchQueue.global(qos: .background)
                let group = DispatchGroup()
                for shuffledUrl in shuffled {
                    group.enter()
                    imageFetchingQueue.async {
                        do {
                            let data = try Data(contentsOf: shuffledUrl)
                            DispatchQueue.main.async {
                                let image = UIImage(data: data)
                                self?.loadedImages.append(image)
                                group.leave()
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func convertAuthorName(name: String) -> String {
        name.replacingOccurrences(of: " ", with: "_")
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
        let filterVC = FilterVC()
        filterVC.modalTransitionStyle = .crossDissolve
        filterVC.modalPresentationStyle = .custom
        filterVC.selectedTagStrings = selectedFilters
        filterVC.dismissClosure = { [weak self] selectedFilters in
            guard let self = self else { return }
            self.selectedFilters = selectedFilters
            self.resetInitialData()
            // load new content
//            self.loadInitialData {
//
//            }
            
            self.dismiss(animated: true)
        }
        present(filterVC, animated: true)
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
        //print(currentPage)
        if currentPage == self.loadedVMs.count - 5 && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            //print(capturedCurrentPage)
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                
                loadNewData(edges: (4, 14)) {
                    
                }
            }
        }
        if currentPage == self.loadedVMs.count - 1 && !isLoadNewDataFunctionRunning {
            capturedCurrentPage = currentPage
            if !isLoadNewDataFunctionRunning {
                isLoadNewDataFunctionRunning = true
                
                loadNewData(edges: (0, 10)) {
                    
                }
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
    
    func displayInitialData(loadedVMs: [QuoteGardenQuoteVM], loadedImages: [UIImage?]) {
        self.loadedVMs = loadedVMs
        self.loadedImages = loadedImages
        self.collectionView.insertItems(at: loadedVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) })
        if self.exploreView.lottieAnimation != nil {
            self.exploreView.stopLottieAnimation()
        }
        self.isDataLoaded = true
    }
}
