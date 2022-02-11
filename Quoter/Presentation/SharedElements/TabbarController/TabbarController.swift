//
//  TabbarController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/25/22.
//

import UIKit
import Combine


class TabbarController: UIViewController {
    
    let tabbarItemsSubject = PassthroughSubject<TabbarItem, Never>()
    var cancellables: Set<AnyCancellable> = []
    
    var prevIndex: Int?
    
    var tabbarView: TabbarView = TabbarView()
    var viewControllers: [UIViewController] {
        tabbarView.tabbarItems.map { $0.controller }
    }
    
    var itemViews: [TabbarItemView] {
        tabbarView.tabbarItems.map { $0.itemView }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tabbarView)

        tabbarView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(20)
            make.height.equalTo(PublicConstants.screenHeight * 0.0739)
        }
    }
    
    private func switchToPage(page: Int) {
        tabbarView.currentItemIndex = page
        print(#function)
    }

    func addTabbarItem(item: TabbarItem) {
        let newItem = item
        let controller = item.controller
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        newItem.itemView.addGestureRecognizer(gesture)
        tabbarView.tabbarItems.append(newItem)
        if let control = controller as? ExploreVC {
            addChildController(controller: control)
        }
    }
    
    func addChildController(controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMove(toParent: self)
        view.bringSubviewToFront(tabbarView)
    }
    
    func removeChildController(controller: UIViewController) {
        controller.removeFromParent()
        view.subviews.forEach { subview in
            if subview === controller.view {
                subview.removeFromSuperview()
            }
        }
        controller.didMove(toParent: self)
    }
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        if let senderView = sender.view as? TabbarItemView {
            let arr = tabbarView.tabbarItems
//            children.forEach { vc in
//                removeChildController(controller: vc)
//            }
            removeChildController(controller: arr[tabbarView.currentItemIndex].controller)
            addChildController(controller: arr[senderView.indexInTabbar].controller)
            tabbarView.currentItemIndex = senderView.indexInTabbar
            //(arr[senderView.indexInTabbar].controller as? ExploreVC)?.configFromSamePage()
        }
    }
}

