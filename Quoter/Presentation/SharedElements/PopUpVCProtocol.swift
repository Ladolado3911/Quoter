//
//  PopUpVCProtocol.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit


protocol PopUpVCProtocol where Self: UIViewController {
    var dimmingView: UIView { get }
    var popUpView: AdPopUpView { get }
    var popUpRectSize: CGSize { get }

    func showView()
    func hideView()
}

extension PopUpVCProtocol {
    
    var popUpRectSize: CGSize {
        CGSize(width: view.bounds.width * 0.8531, height: view.bounds.width * 0.8531 * 1.57875)
    }
    
    func showView() {
        let x: CGFloat = (view.bounds.width / 2) - (popUpRectSize.width / 2)
        let y: CGFloat = (view.bounds.height / 2) - (popUpRectSize.height / 2)
        let finalRect = CGRect(x: x, y: y, width: popUpRectSize.width, height: popUpRectSize.height)
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.popUpView.frame = finalRect
        }
    }
    func hideView() {
        let x: CGFloat = (view.bounds.width / 2)
        let y: CGFloat = (view.bounds.height / 2)
        let finalRect = CGRect(x: x, y: y, width: 0, height: 0)
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.popUpView.frame = finalRect
        }
    }
}

extension AdPopUpView {
    func showContent() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            for subview in self.subviews {
                subview.alpha = 1
            }
        }
    }
    func hideContent() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            for subview in self.subviews {
                subview.alpha = 0
            }
        }
    }
}
