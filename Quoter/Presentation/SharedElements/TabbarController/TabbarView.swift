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
    var currentItemIndex: Int = 0 {
        didSet {
            layoutSubviews()
        }
    }

    let movingRectView: UIView = {
        let movingRectView = UIView()
        movingRectView.backgroundColor = .black
        movingRectView.layer.cornerRadius = PublicConstants.screenHeight * 0.0352
        movingRectView.layer.borderWidth = 1
        movingRectView.layer.borderColor = UIColor.white.cgColor
        return movingRectView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = PublicConstants.screenHeight * 0.0352
        initialSetup()
        setPagesToItems()
    }
    
    private func initialSetup() {
        
        // MARK: Constants
        
        // Set up items
        
        let views = tabbarItems.map { $0.itemView }
        let itemHeight = bounds.height * 0.833
        let itemWidth = (bounds.width / CGFloat(views.count)) * 0.6
        let itemY = bounds.height / 2 - (itemHeight / 2)
        let distanceOnEdge: CGFloat = bounds.width * 0.134
        let tabbarWidthWithoutEdges = bounds.width - (2 * distanceOnEdge)
        let spaceBetweenItems: CGFloat = (tabbarWidthWithoutEdges - (CGFloat(views.count) * itemWidth)) / CGFloat((views.count - 1))
        
        // Set up moving rect
        
        let movingRectWidth = bounds.width * 0.5692
        let movingRectHeight = bounds.height
        let movingRectY: CGFloat = 0
        
        // MARK: Variables
        
        var itemX: CGFloat = distanceOnEdge
        var movingRectX: CGFloat = 0
        
        // MARK: For Loop
        
        for index in 0..<views.count {
            let itemFrame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)

            if index == currentItemIndex {
                tabbarItems[index].itemView.state = .on
                movingRectX = ((itemX + (itemWidth / 2)) - (movingRectWidth / 2))
            }
            itemX += (CGFloat(index + 1) * (itemWidth + spaceBetweenItems))
            
            let movingRectFrame = CGRect(x: movingRectX,
                                         y: movingRectY,
                                         width: movingRectWidth,
                                         height: movingRectHeight)
            
            tabbarItems[index].itemView.frame = itemFrame
            movingRectView.frame = movingRectFrame
            addSubview(views[index])
            addSubview(movingRectView)
            sendSubviewToBack(movingRectView)
        }
    }
    
    private func setPagesToItems() {
        for index in 0..<tabbarItems.count {
            tabbarItems[index].itemView.indexInTabbar = index
        }
    }
}
