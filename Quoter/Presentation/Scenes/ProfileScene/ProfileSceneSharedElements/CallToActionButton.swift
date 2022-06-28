//
//  CallToActionButtonView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

enum FormType: String {
    case signUp = "Sign up"
    case signIn = "Sign in"
    case verification = "Verify"
    case signOut = "Sign out"
}

class CallToActionButton: UIButton {
    
    var callToActionButtonType: FormType? {
        didSet {
            guard let callToActionButtonType = callToActionButtonType else {
                return
            }
            setTitle(callToActionButtonType.rawValue, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.lightBlack
        setTitleColor(DarkModeColors.white, for: .normal)
        layer.applySketchShadow(color: DarkModeColors.black,
                                alpha: 0.7,
                                x: 1,
                                y: 4,
                                blur: 4,
                                spread: 0)
        layer.cornerRadius = 10
    }
    
    func startAnimating() {
        titleLabel?.alpha = 0
        isEnabled = false
        let size = bounds.height * 1.3
        let frame = CGRect(x: bounds.width / 2 - (size / 2),
                           y: bounds.height / 2 - (size / 2),
                           width: size,
                           height: size)
        createAndStartLoadingLottieAnimation(animation: .simpleLoading,
                                             animationSpeed: 1,
                                             frame: frame,
                                             loopMode: .loop,
                                             contentMode: .scaleAspectFit,
                                             completion: nil)
    }
    
    func stopAnimating() {
        stopLoadingLottieAnimationIfExists()
        titleLabel?.alpha = 1
        isEnabled = true
    }
}
