//
//  ScrollIndicatorVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/17/22.
//

import UIKit

class ScrollIndicatorVC: UIViewController {
    
    var repeatCount: Float?

    lazy var scrollIndicatorView: LottieView = {
        let view = ScrollIndicatorView(frame: view.bounds)
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view = scrollIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repeatCount = repeatCount else {
            return
        }
        scrollIndicatorView.createAndStartLottieAnimation(animation: .swipeLeft,
                                                          animationSpeed: 1,
                                                          frame: view.bounds,
                                                          loopMode: .repeat(repeatCount),
                                                          contentMode: .scaleAspectFit)
    }
    
}
