//
//  IdeaImageView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/30/22.
//

import UIKit

enum State {
    case on
    case off
}

class IdeaImageView: UIImageView {
    
    var state: State = .off {
        didSet {
            if state != oldValue {
                switch state {
                case .on:
                    image = UIImage(named: "IdeaOn")
                case .off:
                    image = UIImage(named: "IdeaOff")
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image = UIImage(named: "IdeaOff")
        isUserInteractionEnabled = true
    }
}
