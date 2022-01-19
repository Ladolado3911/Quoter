//
//  ExploreVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class ExploreVC: UIViewController {
    
    var quoteControllers = [QuoteVC(), QuoteVC()]
    
    let pageVC: UIPageViewController = {
        let pageVC = UIPageViewController(transitionStyle: .pageCurl,
                                          navigationOrientation: .horizontal,
                                          options: nil)
        return pageVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configPageVC()
        present(pageVC, animated: false)
    }
    
    private func configPageVC() {
        guard let first = quoteControllers.first else { return }
        
        pageVC.modalTransitionStyle = .crossDissolve
        pageVC.modalPresentationStyle = .fullScreen
        
        pageVC.setViewControllers([first],
                                  direction: .forward,
                                  animated: true,
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
}
