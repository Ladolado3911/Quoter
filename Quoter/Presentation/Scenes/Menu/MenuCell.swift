//
//  MenuCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

class MenuCell: UITableViewCell {

     var menuItem: MenuItem? {
         didSet {
             guard let menuItem = menuItem else { return }
             let menuView = MenuItemView(frame: bounds, with: menuItem)
             addSubview(menuView)
         }
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
    }

    
}
