//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class ExploreVC: UIViewController {
    
    var quoteControllers: [QuoteVC] = []
    var currentIndex: Int = 0
 
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
        UIApplication.shared.statusBarStyle = .lightContent
        configPageVC()
        setUpInitialDataForPageController()
    }
    
    private func setUpInitialDataForPageController() {
        let semaphore = DispatchSemaphore(value: 1)
        getRandomQuote(semaphore: semaphore)
        semaphore.wait()
        getRandomQuote(semaphore: semaphore)
    }
    
    private func getRandomQuote(semaphore: DispatchSemaphore) {
        QuoteManager.getRandomQuote { [weak self] result in
            print("2")
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                print("success 2")
                let vc = QuoteVC()
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                self.configPageVC()
                self.pageVC.dismiss(animated: false) {
                    self.present(self.pageVC, animated: false) {
                        semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getRandomQuote() {
        print(#function)
        QuoteManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                let vc = QuoteVC()
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                //self.configPageVC()
                self.pageVC.dismiss(animated: false) {
                    self.present(self.pageVC, animated: false) {
                        //semaphore.signal()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func configPageVC() {
        guard let first = quoteControllers.first else { return }

        pageVC.modalTransitionStyle = .crossDissolve
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.setViewControllers([first],
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
        if finished {
            print("finished")
        }
        if completed {
            print("completed")
            if currentIndex + 2 == quoteControllers.count {
                print("fetch")
                getRandomQuote()
            }
        }
    }
}
