//
//  MenuView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: bounds)
        table.backgroundColor = DarkModeColors.mainBlack
        return table
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(tableView)
//        let width = bounds.width * 0.7
//        let height: CGFloat = 20
//        let spacing: CGFloat = 30
//        let x: CGFloat = 20
//        var currentY: CGFloat = 132
//
//        for itemView in MenuModels.shared.menuItemViews {
//            addSubview(itemView)
//            let frame = CGRect(x: x, y: currentY, width: width, height: height)
//            itemView.frame = frame
//            currentY = currentY + spacing + height
//        }
    }
    
    private func buildConstraints() {
        
    }
}
