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

class ExploreVC: UIViewController {
    
    var quoteControllers: [QuoteVC] = []
    var loadedVMs: [QuoteVM] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
//        configPageVC()
//        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print(currentPage)
        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print(currentPage)
    }
    
    private func setUpInitialDataForPageController() {
        
        loadImages { [weak self] in
            guard let self = self else { return }
            
            self.showInitialQuote()
        }
//        let group = DispatchGroup()
//        group.enter()
//        loadImages() {
//            group.leave()
//        }
//        group.enter()
//        loadQuotes() {
//            group.leave()
//        }
//        group.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            self.showInitialQuote()
//            //print(self.loadedImageURLs.count)
//            //print(Set(self.loadedImageURLs).count)
//
//        }
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
        QuoteManager.load150Quotes(page: Int.random(in: 1...5),
                                   maxLength: Int(PublicConstants.screenHeight * 0.088)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quotes):
                let shuffled = quotes.shuffled()
                self.loadedVMs.append(contentsOf: shuffled)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showInitialQuote() {
        let vc1 = QuoteVC()
        let vc2 = QuoteVC()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DictumManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                vc1.mainImageURL = self.loadedImageURLs[self.currentPage]
                vc1.quoteVM = quoteVM
                dispatchGroup.leave()
            case .failure(let error):
                print(error)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.enter()
        DictumManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                vc2.mainImageURL = self.loadedImageURLs[self.currentPage + 1]
                vc2.quoteVM = quoteVM
                dispatchGroup.leave()
            case .failure(let error):
                print(error)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.quoteControllers.append(vc1)
            self.quoteControllers.append(vc2)
            self.configPageVC()
            //tempQuoteVM = loadedVMs[currentPage]
            //currentPage += 2
            (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
        }

//        vc1.mainImageURL = loadedImageURLs[currentPage]
//        vc1.quoteVM = loadedVMs[currentPage]
//        vc2.mainImageURL = loadedImageURLs[currentPage + 1]
//        vc2.quoteVM = loadedVMs[currentPage + 1]
//
    }
    
    private func showQuote() {
        let vc = QuoteVC()
        print(currentPage)
        
        DictumManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                vc.mainImageURL = self.loadedImageURLs[self.currentPage + 1]
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                //self.tempQuoteVM = loadedVMs[currentPage + 1]
                (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func configPageVC() {
        //print(currentPage)
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
                if currentPage % 49 == 0 && currentPage != 0 {
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
