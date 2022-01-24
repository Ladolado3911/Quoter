//
//  TestVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/24/22.
//

import UIKit
import SnapKit

class TestVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let tabbarView: TabbarView = TabbarView()
        
        let tabbarItemView1 = TabbarItemView()
        tabbarItemView1.itemName = "Explore"
        tabbarItemView1.icon = UIImage(named: "explore2")
        let tabbarItem1 = TabbarItem(itemView: tabbarItemView1, controller: UIViewController())
        
        let tabbarItemView2 = TabbarItemView()
        tabbarItemView2.itemName = "Profile"
        tabbarItemView2.icon = UIImage(named: "person")
        let tabbarItem2 = TabbarItem(itemView: tabbarItemView2, controller: UIViewController())
        
        tabbarView.tabbarItems = [tabbarItem1, tabbarItem2]
        
        view.addSubview(tabbarView)
        
        tabbarView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(20)
            make.height.equalTo(PublicConstants.screenHeight * 0.0739)
        }
    }
}
