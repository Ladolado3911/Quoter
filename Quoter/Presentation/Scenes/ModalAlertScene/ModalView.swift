//
//  ModalView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

class ModalView: LottieView {
    
    lazy var finalAnimationRect: CGRect = {
        let width = PublicConstants.screenWidth * 0.674311
        let height = PublicConstants.screenHeight * 0.428571
        let x = bounds.width / 2 - (width / 2)
        let y = bounds.height / 2 - (height / 2)
        let animationFrame = CGRect(x: x, y: y, width: width, height: height)
        return animationFrame
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
    }
    
    func startAnimating() {
        createAndStartLottieAnimation(animation: .cubeLoading,
                                      animationSpeed: 0.7,
                                      frame: finalAnimationRect,
                                      loopMode: .loop,
                                      contentMode: .scaleAspectFit)
    }
}
