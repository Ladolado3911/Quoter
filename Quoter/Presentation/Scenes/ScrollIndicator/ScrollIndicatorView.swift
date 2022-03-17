//
//  ScrollIndicatorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/17/22.
//

import UIKit

class ScrollIndicatorView: LottieView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black.withAlphaComponent(0.5)
    }
}
