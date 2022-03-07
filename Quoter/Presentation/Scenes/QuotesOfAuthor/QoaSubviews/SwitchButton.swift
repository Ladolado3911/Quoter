//
//  SwitchButton.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/7/22.
//

import UIKit

class SwitchButton: UIButton {
    
    var isButtonEnabled: Bool = false {
        didSet {
            if isButtonEnabled != oldValue {
                if isButtonEnabled {
                    enableButton()
                }
                else {
                    disableButton()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 3
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        
        switch isButtonEnabled {
        case true:
            enableButton()
        case false:
            disableButton()
        }
    }
    
    private func enableButton() {
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        isUserInteractionEnabled = true
    }
    
    private func disableButton() {
        backgroundColor = .gray
        setTitleColor(.white, for: .normal)
        isUserInteractionEnabled = false
    }
}
