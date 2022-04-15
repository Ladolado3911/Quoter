//
//  MenuModels.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

final class MenuModels {
    
    static let shared = MenuModels()
    
    var menuItems: [MenuItem] = [
        MenuItem(title: "Explore", icon: MenuIcons.exploreIcon, viewController: ExploreVC()),
        MenuItem(title: "Test", icon: MenuIcons.defaultIcon, viewController: TestVC()),
        MenuItem(title: "Explore", icon: MenuIcons.exploreIcon, viewController: ExploreVC()),
        MenuItem(title: "Test", icon: MenuIcons.defaultIcon, viewController: TestVC()),
        MenuItem(title: "Explore", icon: MenuIcons.exploreIcon, viewController: ExploreVC()),
        MenuItem(title: "Test", icon: MenuIcons.defaultIcon, viewController: TestVC()),
    
    
    ]
    
    lazy var menuItemViews: [MenuItemView] = {
        return menuItems.map { MenuItemView(frame: .zero, with: $0) }
    }()
    
    private init() {}
    
    
}

