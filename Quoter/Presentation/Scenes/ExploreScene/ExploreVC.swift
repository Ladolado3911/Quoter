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

class ExploreVC: MonitoredVC {
    
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
    
    override func loadView() {
        super.loadView()
        view = LottieView(frame: view.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
        if let lottieView = self.view as? LottieView {
            let size = view.bounds.width / 3.5
            let x = view.bounds.width / 2 - (size / 2)
            let y = view.bounds.height / 2 - (size / 2)
            let frame = CGRect(x: x, y: y, width: size, height: size)
            lottieView.createAndStartLottieAnimation(animation: .circleLoading,
                                                     animationSpeed: 1,
                                                     frame: frame,
                                                     loopMode: .loop,
                                                     contentMode: .scaleAspectFit)
            self.loadInitialData {
//                lottieView.stopLottieAnimation()
            }
            self.view.addSubview(self.collectionView)
            self.collectionView.snp.makeConstraints { make in
                make.left.right.top.bottom.equalTo(self.view)
            }
        }
//        connectionStatusSubject
//            .sink { [weak self] (isConnected, isFirstLaunch) in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    if isConnected {
//                        print("connected")
//                        if let lottieView = self.view as? LottieView {
//                            if lottieView.lottieAnimation != nil {
//                                lottieView.stopLottieAnimation()
//                            }
//                        }
//                        if isFirstLaunch {
////                            if let lottieView = self.view as? LottieView {
////                                lottieView.createAndStartLottieAnimation(animation: .circleLoading,
////                                                                         animationSpeed: 1,
////                                                                         frame: self.view.bounds,
////                                                                         loopMode: .loop,
////                                                                         contentMode: .scaleAspectFit)
////                            }
//                            self.loadInitialData {
////                                if let lottieView = self.view as? LottieView {
////                                    lottieView.stopLottieAnimation()
////                                }
//                            }
//                            self.view.addSubview(self.collectionView)
//                            self.collectionView.snp.makeConstraints { make in
//                                make.left.right.top.bottom.equalTo(self.view)
//                            }
//                        }
//                        else {
//                        }
//                    }
//                    else {
//                        print("not connected")
//                        if let lottieView = self.view as? LottieView {
//                            if lottieView.lottieAnimation != nil {
//                                lottieView.stopLottieAnimation()
//                            }
//                        }
//                        self.startWifiAnimation()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//
//        NetworkMonitor.shared.startMonitoring { [weak self] path in
//            if NetworkMonitor.shared.isFirstCheck {
//                self?.connectionStatusSubject.send((path.status != .unsatisfied, true))
////                NetworkMonitor.shared.isFirstCheck = false
//            }
//            else {
//                self?.connectionStatusSubject.send((path.status == .unsatisfied, false))
//            }
//        }
    }
    
    private func resetInitialData() {
        isDataLoaded = false
        loadedVMs = []
        loadedImages = []
        currentPage = 0
        capturedCurrentPage = 0
        collectionView.reloadData()
        if let lottieView = view as? LottieView {
            let size = view.bounds.width / 3.5
            let x = view.bounds.width / 2 - (size / 2)
            let y = view.bounds.height / 2 - (size / 2)
            let frame = CGRect(x: x, y: y, width: size, height: size)
            lottieView.createAndStartLottieAnimation(animation: .circleLoading,
                                                     animationSpeed: 1,
                                                     frame: frame,
                                                     loopMode: .loop,
                                                     contentMode: .scaleAspectFit)
        }
        loadImages { [weak self] in
            guard let self = self else { return }
            self.load10RandomQuotes {
                if let lottieView = self.view as? LottieView {
                    lottieView.stopLottieAnimation()
                }
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
                if let lottieView = self.view as? LottieView {
                    if lottieView.lottieAnimation != nil {
                        lottieView.stopLottieAnimation()
                    }
                }
                self.isDataLoaded = true
            }
        }
    }
//
//    private func loadNewData(completion: @escaping () -> Void) {
//        loadImages { [weak self] in
//            guard let self = self else { return }
//            self.load10RandomQuotes {
//                let indexPaths = self.loadedVMs.enumerated().map { IndexPath(item: $0.offset, section: 0) }
//                self.collectionView.insertItems(at: Array(indexPaths[(self.capturedCurrentPage + 4)...self.capturedCurrentPage + 14]))
//                self.collectionView.isUserInteractionEnabled = true
//                self.isLoadNewDataFunctionRunning = false
//                self.dismiss(animated: false)
//            }
//        }
//    }
    
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
        if let lottieView = view as? LottieView {
            if lottieView.lottieAnimation != nil {
//                lottieView.stopLottieAnimation()
                connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))
            }
            else {
                if !isDataLoaded {
                    let size = view.bounds.width / 3.5
                    let x = view.bounds.width / 2 - (size / 2)
                    let y = view.bounds.height / 2 - (size / 2)
                    let frame = CGRect(x: x, y: y, width: size, height: size)
                    lottieView.createAndStartLottieAnimation(animation: .circleLoading,
                                                             animationSpeed: 1,
                                                             frame: frame,
                                                             loopMode: .loop,
                                                             contentMode: .scaleAspectFit)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let lottieView = view as? LottieView {
            if lottieView.lottieAnimation != nil {
                lottieView.stopLottieAnimation()
                lottieView.lottieAnimation = nil
            }
        }
    }
    
    private func startWifiAnimation() {
        if let lottieView = view as? LottieView {
            lottieView.createAndStartLottieAnimation(animation: .wifiOff,
                                                     animationSpeed: 2,
                                                     frame: animationFrame,
                                                     loopMode: .autoReverse,
                                                     contentMode: .scaleAspectFit)
        
        }
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let castedCell = cell as? QuoteCell
//        castedCell?.quoteVM = loadedVMs[indexPath.item]
//        castedCell?.mainImageURL = loadedImageURLs[indexPath.item]
//    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let width = scrollView.frame.width - (scrollView.contentInset.left * 2)
//        let index = scrollView.contentOffset.x / width
//        let roundedIndex = round(index)
//        currentPage = Int(roundedIndex)
//    }
    
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
