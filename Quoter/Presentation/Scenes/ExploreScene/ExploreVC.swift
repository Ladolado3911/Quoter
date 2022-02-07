//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class ExploreVC: UIViewController {
    
    var quoteControllers: [QuoteVC] = []
    var loadedVMs: [QuoteVM] = []
    var loadedImageURLs: [URL?] = []
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
        print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
//        configPageVC()
//        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(currentPage)
        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    private func setUpInitialDataForPageController() {
//        getRandomQuote(semaphore: semaphore)
//        semaphore.wait()
//        getRandomQuote(semaphore: semaphore)
//        let group = DispatchGroup()
//        group.enter()
//        loadImages() {
//            group.leave()
//        }
        //group.enter()
        loadQuotes() { [weak self] in
            self?.showInitialQuote()
        }
//        group.notify(queue: .main) { [weak self] in
//            guard let self = self else { return }
//            self.showInitialQuote()
//        }
    }
    
    private func loadImages(completion: @escaping () -> Void) {
        QuoteManager.load150ImageURLs(page: Int.random(in: 1...3)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urls):
                let shuffled = urls.shuffled()
                self.loadedImageURLs.append(contentsOf: shuffled)
                completion()
            case .failure(let error):
                print(error)
            }
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
//        vc1.mainImageURL = loadedImageURLs[currentPage]
        vc1.quoteVM = loadedVMs[currentPage]
 //       vc2.mainImageURL = loadedImageURLs[currentPage + 1]
        vc2.quoteVM = loadedVMs[currentPage + 1]
        quoteControllers.append(vc1)
        quoteControllers.append(vc2)
        configPageVC()
        tempQuoteVM = loadedVMs[currentPage]
        currentPage += 2
        (parent as? TabbarController)?.addChildController(controller: self.pageVC)
    }
    
    private func showQuote() {
        let vc = QuoteVC()
        //vc.mainImageURL = loadedImageURLs[currentPage]
        vc.quoteVM = loadedVMs[currentPage]
        quoteControllers.append(vc)
        tempQuoteVM = loadedVMs[currentPage]
        (parent as? TabbarController)?.addChildController(controller: self.pageVC)
    }

    private func configPageVC() {
        let current = quoteControllers[currentPage]
        pageVC.modalTransitionStyle = .crossDissolve
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.setViewControllers([current],
                                  direction: .forward,
                                  animated: false,
                                  completion: nil)
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
            if currentX > prevX {
                //print("turn page to left")
                currentPage -= 1
            }
            else {
                if currentPage % 150 == 0 && currentPage != 0 {
                    print("limit reached")
                    //let group = DispatchGroup()
                    //group.enter()
                    loadQuotes { [weak self] in
                        //group.leave()
                        self?.showQuote()
                    }
//                    group.enter()
//                    loadImages {
//                        group.leave()
//                    }
//                    group.notify(queue: .main) { [weak self] in
//                        self?.showQuote()
//                    }
                }
                else {
                    showQuote()
                }
                currentPage += 1
            }
//            if currentIndex + 2 == quoteControllers.count && currentX < prevX {
//                getRandomQuote()
//            }
        }
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageViewController.gestureRecognizers.forEach { recognizer in
            if let recog = recognizer as? UIPanGestureRecognizer {
                prevX = recog.location(in: pageViewController.view).x
            }
        }
    }
}
