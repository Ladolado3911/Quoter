//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class ExploreVC: UIViewController {
    
    var quoteControllers: [QuoteVC] = []
    var currentPage: Int = 0
    var currentIndex: Int = 0
    var currentX: CGFloat = 0
    var prevX: CGFloat = -1
 
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
        setUpInitialDataForPageController()
        //configPageVC()
    }
    
    private func setUpInitialDataForPageController() {
        let semaphore = DispatchSemaphore(value: 1)
        getRandomQuote(semaphore: semaphore)
        semaphore.wait()
        getRandomQuote(semaphore: semaphore)
    }
    
    private func getRandomQuote(semaphore: DispatchSemaphore) {
        QuoteManager.getRandomQuote(maxLength: Int(PublicConstants.screenHeight * 0.088)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                let vc = QuoteVC()
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                self.configPageVC()
                (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
                //print("getRandomQuoteSemaphore finished")
                semaphore.signal()
//                self.pageVC.dismiss(animated: false) {
//                    //self.configPageVC()
////                    self.present(self.pageVC, animated: false) {
////                        semaphore.signal()
////                    }
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getRandomQuote() {
        //print(#function)
        QuoteManager.getRandomQuote(maxLength: Int(PublicConstants.screenHeight * 0.088)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                let vc = QuoteVC()
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                //self.configPageVC()
                (self.parent as? TabbarController)?.addChildController(controller: self.pageVC)
                //print("getRandomQuote finished")
                //self.quoteControllers[self.currentPage - 1].view.isUserInteractionEnabled = true
//                self.pageVC.dismiss(animated: false) {
//                    self.present(self.pageVC, animated: false) {
//                        //semaphore.signal()
//                    }
//                }
            case .failure(let error):
                print(error)
            }
        }
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
                //quoteControllers[currentPage].view.isUserInteractionEnabled = false
                //print("turn page to right")
                getRandomQuote()
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
