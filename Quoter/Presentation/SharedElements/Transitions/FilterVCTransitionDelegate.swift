//
//  FilterVCTransition.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/7/22.
//

import UIKit

class FilterVCTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterVCPresentationController(presentedViewController: presented, presenting: presenting)
    }

    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        FilterVCTransitionAnimator()
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        FilterVCTransitionAnimator()
//    }
    
}


