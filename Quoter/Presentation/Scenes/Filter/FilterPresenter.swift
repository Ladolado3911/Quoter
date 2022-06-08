//
//  FilterPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterPresenterProtocol {
    var vc: FilterVCProtocol? { get set }
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder)
    func panFunc2(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder)

    func animateMovement(direction: MovementDirection)
    func animateColor()
    func dismiss()
    
}

class FilterPresenter: FilterPresenterProtocol {
    var vc: FilterVCProtocol?
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder) {
        let minY = targetView.frame.minY
        let dragVelocity = sender.velocity(in: targetView)
        
        vc?.panFunc(sender: sender, targetView: targetView, minY: minY, dragVelocity: dragVelocity)
    }
    
    func panFunc2(sender: UIPanGestureRecognizer, targetView: ModalViewWithTopBorder) {
        
    }
    
    func animateMovement(direction: MovementDirection) {
        switch direction {
        case .up:
            vc?.animate(to: CGPoint(x: -5, y: Constants.screenHeight * 0.1831))
        case .down:
            vc?.animate(to: CGPoint(x: -5, y: Constants.screenHeight))
        }
    }
    
    func animateColor() {
        vc?.animateColor()
    }

    func dismiss() {
        vc?.dismiss()
    }

}
