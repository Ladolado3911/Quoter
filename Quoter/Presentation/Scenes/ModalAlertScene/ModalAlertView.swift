//
//  ModalAlertView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit
import SnapKit

class ModalAlertView: UIView {
    
    lazy var modalFinalFrame: CGRect = {
        let width = PublicConstants.screenWidth * 0.68125
        let height = PublicConstants.screenHeight * 0.36971
        let x = bounds.width / 2 - (width / 2)
        let y = bounds.height / 2 - (height / 2)
        return CGRect(x: x, y: y, width: width, height: height)
    }()

    lazy var modalView: ModalView = {
        let modalView = ModalView(frame: initialFrame)
        return modalView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black.withAlphaComponent(0.72)
        buildSubviews()
        //buildView()
    }
    
    private func buildSubviews() {
        addSubview(modalView)
    }
    
    func buildView(authorName: String) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.modalView.frame = self.modalFinalFrame
        } completion: { didFinish in
            if didFinish {
                print("didFinish")
                self.modalView.startAnimating(authorName: authorName)
            }
        }
    }
}
