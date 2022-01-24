//
//  TabbarController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/24/22.
//

import UIKit
import SnapKit

struct TabbarItem {
    var itemView: TabbarItemView
    var controller: UIViewController
}

class TabbarView: UIView {
    
    var tabbarItems: [TabbarItem] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = bounds.width * 0.0858
        initialSetup()
    }
    
    private func initialSetup() {
        
        // MARK: Constants
        
        let views = tabbarItems.map { $0.itemView }
        let itemHeight = bounds.height * 0.833
        let itemWidth = (bounds.width / CGFloat(views.count)) * 0.6
        let itemY = bounds.height / 2 - (itemHeight / 2)
        let distanceOnEdge: CGFloat = bounds.width * 0.134
        let tabbarWidthWithoutEdges = bounds.width - (2 * distanceOnEdge)
        let spaceBetweenItems: CGFloat = (tabbarWidthWithoutEdges - (CGFloat(views.count) * itemWidth)) / CGFloat((views.count - 1))
        
        // MARK: Variables
        
        var itemX: CGFloat = distanceOnEdge
        
        // MARK: For Loop
        
        for index in 0..<views.count {
            let itemFrame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            itemX += (CGFloat(index + 1) * (itemWidth + spaceBetweenItems))
            tabbarItems[index].itemView.frame = itemFrame
            addSubview(views[index])
        }
    }
    
    
}
