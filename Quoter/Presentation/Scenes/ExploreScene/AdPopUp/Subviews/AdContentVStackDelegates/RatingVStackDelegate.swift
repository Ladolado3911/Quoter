//
//  File.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class StarsView: UIView {
    
    
    
}

final class RatingVStackDelegate: AdContentDelegateProtocol {

    let ratingView: RatingView = {
        let ratingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    var rootVStack: UIStackView?
    var configurator: AdVStackConfiguratorModel?
    
    init(configurator: AdVStackConfiguratorModel) {
        self.configurator = configurator
    }
    
    func configVStack() {
        if let lowerContent = configurator?.lowerContentInfo as? Double {
            ratingView.starsCount = CGFloat(lowerContent)
        }
        rootVStack!.addArrangedSubview(ratingView)
    }
}
