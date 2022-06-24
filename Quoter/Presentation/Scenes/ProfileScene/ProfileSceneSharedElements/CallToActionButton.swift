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
}
