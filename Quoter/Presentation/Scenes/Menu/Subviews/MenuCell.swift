//
//  MenuCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

class MenuCell: UITableViewCell {
    
    var menuView: MenuItemView?
    
    var menuItem: MenuItem? {
        didSet {
            guard let menuItem = menuItem else { return }
            for subview in subviews {
                subview.removeFromSuperview()
            }
            let menuView = MenuItemView(frame: bounds, with: menuItem)
            self.menuView = menuView
            addSubview(menuView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        selectionStyle = .none
    }
    
    
}
