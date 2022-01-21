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
    
    let pageVC: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        return pageVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
//        QuoteManager.getRandomQuote { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let quoteVM):
//                let vc = QuoteVC()
//                vc.quoteVM = quoteVM
//                self.quoteControllers.append(vc)
//                self.reloadPageVC()
//            case .failure(let error):
//                print(error)
//            }
//        }
//        QuoteManager.getRandomQuote { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let quoteVM):
//                let vc = QuoteVC()
//                vc.quoteVM = quoteVM
//                self.quoteControllers.append(vc)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configPageVC()
        present(pageVC, animated: false)
        QuoteManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                let vc = QuoteVC()
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                self.configPageVC()
            case .failure(let error):
                print(error)
            }
        }
        QuoteManager.getRandomQuote { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quoteVM):
                let vc = QuoteVC()
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
                vc.quoteVM = quoteVM
                self.quoteControllers.append(vc)
                self.configPageVC()
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

        pageVC.dataSource = self
        pageVC.delegate = self
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
