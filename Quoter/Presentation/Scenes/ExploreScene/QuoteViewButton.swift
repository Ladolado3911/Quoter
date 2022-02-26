//
//  QuoteViewButton.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/16/22.
//

import UIKit
import SnapKit

class QuoteViewButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(title: String, icon: UIImage) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.background = .clear()
        //configuration.cornerStyle = .fixed
        configuration.image = icon.resizedImage(targetHeight: PublicConstants.screenHeight * 0.035211267605633804)
        
        configuration.titlePadding = 10
        configuration.imagePadding = 10
        //configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
        self.init(configuration: configuration, primaryAction: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        //sizeToFit()

        let blurEffect = UIBlurEffect(style: .init(rawValue: 101)!)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true

        addSubview(blurEffectView)
        sendSubviewToBack(blurEffectView)

        layer.cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.7
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.font = titleLabel?.font.withSize(PublicConstants.screenHeight * 0.0182)
    }
}
