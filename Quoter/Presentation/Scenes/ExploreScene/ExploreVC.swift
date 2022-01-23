//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class ExploreVC: UIViewController {
    
    var quoteControllers: [QuoteVC] = [] {
        didSet {
            
        }
    }
    
    var isPresenting = false
    
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
        let semaphore = DispatchSemaphore(value: 1)

        QuoteManager.getRandomQuote { [weak self] result in
            print("1")
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                print("success 1")
                let vc = QuoteVC()
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                self.configPageVC()
                self.pageVC.dismiss(animated: false) {
                    self.present(self.pageVC, animated: false) {
                        semaphore.signal()
                    }
                    //semaphore.signal()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        semaphore.wait()
        
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
                    //semaphore.signal()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    private func configPageVC() {
        guard let first = quoteControllers.first else { return }

        pageVC.modalTransitionStyle = .crossDissolve
        pageVC.modalPresentationStyle = .fullScreen
        
//        pageVC.viewControllers?.forEach({ vc in
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .fullScreen
//        })
    
        pageVC.setViewControllers([first],
                                  direction: .forward,
                                  animated: false,
                                  completion: nil)

    }
}

extension ExploreVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = quoteControllers.firstIndex(of: viewController as! QuoteVC), index > 0 else { return nil }
        let before = index - 1
        return quoteControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = quoteControllers.firstIndex(of: viewController as! QuoteVC), index < (quoteControllers.count - 1) else { return nil }
        let after = index + 1
        return quoteControllers[after]
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if !completed { return }
//            DispatchQueue.main.async() { [weak self] in
//                guard let self = self else { return }
//                self.pageVC.dataSource = nil
//                self.pageVC.dataSource = self
//            }
//    }
}
