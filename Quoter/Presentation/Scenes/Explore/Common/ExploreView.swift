//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit

class ExploreView: LottieView {
    
    func startAnimating() {
        let size = bounds.width / 3.5
        let x = bounds.width / 2 - (size / 2)
        let y = bounds.height / 2 - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        createAndStartLottieAnimation(animation: .circleLoading,
                                      animationSpeed: 1,
                                      frame: frame,
                                      loopMode: .loop,
                                      contentMode: .scaleAspectFit)
    }
    
    func stopAnimating() {
        //darkView.isHidden = false
        stopLottieAnimation()
    }
    
}
