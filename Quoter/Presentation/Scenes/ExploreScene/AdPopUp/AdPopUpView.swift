//
//  AdPopUpView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class AdPopUpView: UIView, PopUpViewProtocol {
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
    }
    
    private func configView() {
        backgroundColor = .white
        layer.cornerRadius = 20
    }
}
