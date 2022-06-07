//
//  FilterVCPresentationController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/7/22.
//

import UIKit

class FilterVCPresentationController: UIPresentationController {
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black
        containerView.addSubview(dimmingView)
//        coordinator.animate { context in
//            dimmingView.alpha = 0.5
//        }
        
        UIView.animate(withDuration: 5) {
            dimmingView.alpha = 0.5
        }
        
        
        
    }
    
    override func dismissalTransitionWillBegin() {
        
    }
}
