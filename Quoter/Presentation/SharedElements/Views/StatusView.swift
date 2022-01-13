//
//  StatusView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit
import SnapKit

enum StatusViewState {
    case small
    case large
}

class StatusView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Quoter"
        label.textColor = .white
        return label
    }()
    
    var state: StatusViewState = .large {
        didSet {
            if state != oldValue {
                setState(with: state)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialSetup()
        
    }
    
    private func setState(with state: StatusViewState) {
        switch state {
        case .small:
            print("set small nav bar")
            setSmallNavBar()
        case .large:
            print("set big nav bar")
            setBigNavBar()
        }
        layoutIfNeeded()
    }
    
    private func initialSetup() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
    }
    
    private func buildConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).inset(44)
        }
    }
    
    private func setSmallNavBar() {
        
    }
    
    private func setBigNavBar() {
        
    }
}
    
