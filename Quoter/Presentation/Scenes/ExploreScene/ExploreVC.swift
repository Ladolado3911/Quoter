//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

enum ScrollingDirection {
    case left
    case right
}

struct TagImageURLs {
    static var wisdom: [URL] = []
    static var friendship: [URL] = []
    static var inspirational: [URL] = []
    static var famousQuotes: [URL] = []
}

enum Tag: String {
    case wisdom
    case friendship
    case inspirational
    case famousQuotes = "famous-quotes"
}

class ExploreVC: MonitoredVC {
    
    var quoteControllers: [QuoteVC] = []
    var loadedVMs: [QuoteGardenQuoteVM] = []
    var loadedImageURLs: [URL?] = []
    
    var scrollingDirection: ScrollingDirection = .right

    var currentPage: Int = 0

    var currentIndex: Int = 0
    var currentX: CGFloat = 0
    var prevX: CGFloat = -1
    
    var tempQuoteVM: QuoteVM?
    
    var currentNetworkPage: Int = 0
    var totalNetworkPages: Int = 0

    lazy var pageVC: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
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
                            self.setUpInitialDataForPageController()
                        }
                        else {
                            
                            self.configPageVC()
                            (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
                        }
                    }
                    else {
                        print("not connected")
                        if let lottieView = self.view as? LottieView {
                            if lottieView.lottieAnimation != nil {
                                lottieView.stopLottieAnimation()
                            }
                        }
                        (self.parent as? TabbarController)?.removeChildController(controller: self.pageVC)
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
    
    private func setUpInitialDataForPageController() {
        if let lottieView = view as? LottieView {
            if lottieView.lottieAnimation != nil {
                lottieView.stopLottieAnimation()
            }
            lottieView.createAndStartLottieAnimation(animation: .circleLoading,
                                                     animationSpeed: 1,
                                                     frame: animationFrame,
                                                     loopMode: .loop,
                                                     contentMode: .scaleAspectFit)
        }
        let group = DispatchGroup()
        group.enter()
        loadImages() {
            group.leave()
        }
        group.enter()
        loadQuotes() {
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.showInitialQuote()
            if let lottieView = self.view as? LottieView {
                lottieView.stopLottieAnimation()
            }
            NetworkMonitor.shared.isFirstCheck = false
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
    
    private func loadQuotes(completion: @escaping () -> Void) {
        QuoteGardenManager.get50Quotes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quotes):
                self.loadedVMs.append(contentsOf: quotes)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showInitialQuote() {
        let vc1 = QuoteVC()
        let vc2 = QuoteVC()
        vc1.mainImageURL = loadedImageURLs[currentPage]
        vc1.quoteVM = loadedVMs[currentPage]
        vc2.mainImageURL = loadedImageURLs[currentPage + 1]
        vc2.quoteVM = loadedVMs[currentPage + 1]
        quoteControllers.append(vc1)
        quoteControllers.append(vc2)
        configPageVC()
        (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
    }
    
    private func showQuote() {
        let vc = QuoteVC()
        vc.mainImageURL = loadedImageURLs[currentPage + 1]
        vc.quoteVM = loadedVMs[currentPage + 1]
        quoteControllers.append(vc)
        (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
    }

    private func configPageVC() {
        let current = quoteControllers[currentPage]
        pageVC.modalTransitionStyle = .crossDissolve
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.setViewControllers([current],
                                  direction: .forward,
                                  animated: false,
                                  completion: nil)
        //currentPage += 2
    }
}

extension ExploreVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = quoteControllers.firstIndex(of: viewController as! QuoteVC), index > 0 else { return nil }
        currentIndex = index
        let before = index - 1
        return quoteControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let castedController = viewController as! QuoteVC
        guard let index = quoteControllers.firstIndex(of: castedController), index < (quoteControllers.count - 1) else {
            return nil
        }
        currentIndex = index
        let after = index + 1
        return quoteControllers[after]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageViewController.gestureRecognizers.forEach { recognizer in
                if let recog = recognizer as? UIPanGestureRecognizer {
                    currentX = recog.location(in: pageViewController.view).x
                }
            }
            switch scrollingDirection {
            case .left:
                currentPage -= 1
            case .right:
                currentPage += 1
            }
            if currentX > prevX {
                //print("turn page to left")
                //currentPage -= 1
            }
            else {
                // if currentPage % 49 == 0 && currentPage != 0
                print(currentPage)
                print(loadedVMs.count - 2)
                if currentPage == loadedVMs.count - 2 && currentPage != 0 {
                    print("limit reached")
                    let group = DispatchGroup()
                    group.enter()
                    loadQuotes { 
                        group.leave()
                    }
                    group.enter()
                    loadImages {
                        group.leave()
                    }
                    group.notify(queue: .main) { [weak self] in
                        self?.showQuote()
                    }
                }
                else {
                    showQuote()
                }
                //currentPage += 1
            }
//            if currentIndex + 2 == quoteControllers.count && currentX < prevX {
//                getRandomQuote()
//            }
            //print(currentPage)
        }
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageViewController.gestureRecognizers.forEach { recognizer in
            if let recog = recognizer as? UIPanGestureRecognizer {
                prevX = recog.location(in: pageViewController.view).x
            }
            if let recog = recognizer as? UITapGestureRecognizer {
                print("tapped")
                let tappedX = recog.location(in: pageViewController.view).x
                if tappedX < PublicConstants.screenWidth / 2 {
                    //currentPage -= 1
                    scrollingDirection = .left
                }
                else {
                    //currentPage += 1
                    scrollingDirection = .right
                }
            }
        }
    }
}
