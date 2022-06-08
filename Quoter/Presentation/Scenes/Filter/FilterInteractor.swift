//
//  FilterInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterInteractorProtocol {
    var presenter: FilterPresenterProtocol? { get set }
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol? { get set }
    
    var hasSetPointOrigin: Bool { get set }
    var pointOrigin: CGPoint? { get set }
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder)
    func panFunc2(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder, minY: CGFloat, dragVelocity: CGPoint)
    func tapFunc(sender: UITapGestureRecognizer, targetView: UIView)
    func animatedDismiss()
    func showView(targetView: ModalViewWithTopBorder)
    func hideView()
    
}

class FilterInteractor: FilterInteractorProtocol {

    var hasSetPointOrigin: Bool = false
    var pointOrigin: CGPoint?
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder) {
        presenter?.panFunc(sender: sender, targetView: targetView)
    }
    
    func panFunc2(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder, minY: CGFloat, dragVelocity: CGPoint) {
        let translation = sender.translation(in: targetView)
        guard translation.y >= 0 else { return }
        targetView.frame.origin = CGPoint(x: -5, y: pointOrigin!.y + translation.y)
        if sender.state == .ended {
            if dragVelocity.y >= 1300 {
                animatedDismiss()
            }
            else if minY >= Constants.screenHeight * 0.55  {
                animatedDismiss()
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    targetView.frame.origin = self.pointOrigin ?? CGPoint(x: -5, y: UIScreen.main.bounds.height * 0.8169)
                }
            }
        }
    }
    
    func tapFunc(sender: UITapGestureRecognizer, targetView: UIView) {
        if sender.location(in: targetView).y < Constants.screenHeight * 0.1831 {
            animatedDismiss()
        }
    }
    
    func animatedDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.presenter?.animateMovement(direction: .down)
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.presenter?.dismiss()
            }
        }
    }
    
    func showView(targetView: ModalViewWithTopBorder) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.presenter?.animateColor()
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.presenter?.animateMovement(direction: .up)
            }
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.pointOrigin = targetView.frame.origin
            }
        }
    }
    
    func hideView() {
        animatedDismiss()
    }
    
    var presenter: FilterPresenterProtocol?
    var exploreNetworkWorker: ExploreNetworkWorkerProtocol?
    
}
