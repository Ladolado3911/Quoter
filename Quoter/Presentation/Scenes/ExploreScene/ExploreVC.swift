//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit
import SnapKit

enum ScrollingDirection {
    case left
    case right
}

//struct TagImageURLs {
//    static var wisdom: [URL] = []
//    static var friendship: [URL] = []
//    static var inspirational: [URL] = []
//    static var famousQuotes: [URL] = []
//}

//enum Tag: String {
//    case wisdom
//    case friendship
//    case inspirational
//    case famousQuotes = "famous-quotes"
//}

class ExploreVC: MonitoredVC {
    
    var quoteControllers: [QuoteVC] = []
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImageURLs: [URL?] = []
    
    var scrollingDirection: ScrollingDirection = .right

    var currentPage: Int = 0 {
        didSet {
            print(currentPage)
        }
    }
    var currentGenre: String = ""

    var currentIndex: Int = 0
    var currentX: CGFloat = 0
    var prevX: CGFloat = -1
    
    var tempQuoteVM: QuoteVM?
    
    var currentNetworkPage: Int = 0
    var totalNetworkPages: Int = 0
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
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
        view = LottieView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
        connectionStatusSubject
            .sink { [weak self] (isConnected, isFirstLaunch) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if isConnected {
                        print("connected")
                        if let lottieView = self.view as? LottieView {
                            if lottieView.lottieAnimation != nil {
                                lottieView.stopLottieAnimation()
                            }
                        }
                        if isFirstLaunch {
                            //self.setUpInitialDataForPageController()
                            self.setUpInitialData()
                            self.view.addSubview(self.collectionView)
                            self.collectionView.snp.makeConstraints { make in
                                make.left.right.top.bottom.equalTo(self.view)
                            }
                        }
                        else {
                            
                            //self.configPageVC()
                            //(self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
                        }
                    }
                    else {
                        print("not connected")
                        if let lottieView = self.view as? LottieView {
                            if lottieView.lottieAnimation != nil {
                                lottieView.stopLottieAnimation()
                            }
                        }
                        //(self.parent as? TabbarController)?.removeChildController(controller: self.pageVC)
                        self.startWifiAnimation()
                    }
                }
            }
            .store(in: &cancellables)
        
        NetworkMonitor.shared.startMonitoring { [weak self] path in
            if NetworkMonitor.shared.isFirstCheck {
                self?.connectionStatusSubject.send((path.status != .unsatisfied, true))
//                NetworkMonitor.shared.isFirstCheck = false
            }
            else {
                self?.connectionStatusSubject.send((path.status == .unsatisfied, false))
            }
        }
        
//        configPageVC()
//        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    private func setUpInitialData() {
        loadImages { [weak self] in
            guard let self = self else { return }
            self.load3RandomQuotes {
                for vmIndex in 0..<self.loadedVMs.count {
                    self.loadedVMs[vmIndex].imageURL = self.loadedImageURLs[vmIndex]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func load3RandomQuotes(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        loadRandomQuote(genre: currentGenre) {
            group.leave()
        }
        group.enter()
        loadRandomQuote(genre: currentGenre) {
            group.leave()
        }
        group.enter()
        loadRandomQuote(genre: currentGenre) {
            group.leave()
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let lottieView = view as? LottieView {
            if lottieView.lottieAnimation != nil {
                lottieView.stopLottieAnimation()
                connectionStatusSubject.send((NetworkMonitor.shared.isConnected, false))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(loadedImageURLs.count)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let lottieView = view as? LottieView {
            if lottieView.lottieAnimation != nil {
                lottieView.stopLottieAnimation()
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
        ImageManager.load50LandscapeURLs { [weak self] result in
            switch result {
            case .success(let urls):
                let shuffled = urls.shuffled().compactMap { $0 }
                self?.loadedImageURLs.append(contentsOf: shuffled)
                
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
}

extension ExploreVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loadedVMs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? QuoteCell
        cell?.quoteVM = loadedVMs[indexPath.item]
        cell?.mainImageURL = loadedImageURLs[indexPath.item]
        //cell.backgroundColor = colors.randomElement()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(collectionView.visibleCells.count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        //print(loadedVMs.map { $0.content })
    }
}
