//
//  FilterVCPresentationController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/7/22.
//

import UIKit

class FilterVCPresentationController: UIPresentationController {
    
    var dimmingView: UIView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                     withParentContainerSize: containerView!.bounds.size)
        frame.origin.x = 0
        frame.origin.y = containerView!.bounds.height - frame.height
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        self.dimmingView = dimmingView
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black
        containerView.addSubview(dimmingView)
        
        coordinator.animate { [weak self] context in
            guard let self = self else { return }
            guard let dimmingView = self.dimmingView else { return }
            dimmingView.alpha = 0.5
        }
        
//        UIView.animate(withDuration: 2) { [weak self] in
//            guard let self = self else { return }
//            guard let dimmingView = self.dimmingView else { return }
//            dimmingView.alpha = 0.5
//        }
        
        
        
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate { [weak self] context in
            guard let self = self else { return }
            guard let dimmingView = self.dimmingView else { return }
            dimmingView.alpha = 0.5
        }
//        UIView.animate(withDuration: 2) { [weak self] in
//            guard let self = self else { return }
//            guard let dimmingView = self.dimmingView else { return }
//            dimmingView.alpha = 0
//        }
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        CGSize(width: parentSize.width, height: parentSize.height * 0.8169)
    }
    
    
}
