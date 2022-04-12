//
//  MenuView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        for itemView in MenuModels.shared.menuItemViews {
            addSubview(itemView)
        }
    }
    
    private func buildConstraints() {
        
    }
}
