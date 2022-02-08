//
//  LottieView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/3/22.
//

import UIKit
import Lottie

class LottieView: UIView {
    var lottieAnimation: AnimationView!
    
    func createAndStartLottieAnimation(animation: LottieAnimation,
                              animationSpeed: CGFloat = 1,
                              frame: CGRect = .zero,
                              loopMode: LottieLoopMode = .loop,
                              contentMode: UIView.ContentMode = .scaleAspectFit) {

        lottieAnimation = AnimationView(name: animation.rawValue)
        lottieAnimation.frame = frame
        lottieAnimation.contentMode = contentMode
        lottieAnimation.loopMode = loopMode
        lottieAnimation.animationSpeed = animationSpeed
        addSubview(lottieAnimation)
        lottieAnimation.play()
    }
    
    func stopLottieAnimation() {
        lottieAnimation.stop()
        lottieAnimation.isHidden = true
    }
}