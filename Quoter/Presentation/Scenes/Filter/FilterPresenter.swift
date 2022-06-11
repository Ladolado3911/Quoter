//
//  FilterPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

protocol FilterPresenterProtocol {
    var vc: FilterVCProtocol? { get set }
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: FilterView)
    func panFunc2(sender: UIPanGestureRecognizer, targetView: FilterView)

    func animateMovement(direction: MovementDirection)
    func animateColor()
    func dismiss()
    
    func reloadCollectionViewData()
    
    func setCurrentGenreToLabel(genre: String)
    
}

class FilterPresenter: FilterPresenterProtocol {
    var vc: FilterVCProtocol?
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: FilterView) {
        let minY = targetView.frame.minY
        let dragVelocity = sender.velocity(in: targetView)
        vc?.panFunc(sender: sender, targetView: targetView, minY: minY, dragVelocity: dragVelocity)
    }
    
    func panFunc2(sender: UIPanGestureRecognizer, targetView: FilterView) {
        
    }
    
    func animateMovement(direction: MovementDirection) {
        switch direction {
        case .up:
            vc?.animate(to: CGPoint(x: -5, y: Constants.screenHeight * 0.3819))
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
    
    func reloadCollectionViewData() {
        vc?.reloadCollectionViewData()
    }
    
    func setCurrentGenreToLabel(genre: String) {
        vc?.setCurrentGenreToLabel(genre: genre)
    }

}
