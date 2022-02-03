//
//  ModalView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/2/22.
//

import UIKit

class ModalView: LottieView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        
        let width = PublicConstants.screenWidth * 0.674311
        let height = PublicConstants.screenHeight * 0.428571
        let x = bounds.width / 2 - (width / 2)
        let y = bounds.height / 2 - (height / 2)
        let animationFrame = CGRect(x: x, y: y, width: width, height: height)
        
        createAndStartLottieAnimation(animation: .cubeLoading,
                                      animationSpeed: 1,
                                      frame: animationFrame,
                                      loopMode: .loop,
                                      contentMode: .scaleAspectFit)
    }
}
