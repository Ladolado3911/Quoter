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
    
    var tabbarView: TabbarView = TabbarView()
//    var tabbarItems: [TabbarItem] = []
//    var currentItemIndex: Int = 1
    var viewControllers: [UIViewController] {
        tabbarView.tabbarItems.map { $0.controller }
    }
    
    var itemViews: [TabbarItemView] {
        tabbarView.tabbarItems.map { $0.itemView }
    }
//
    lazy var onTapGesture: UITapGestureRecognizer = {
        let onTapGesture = UITapGestureRecognizer(target: self,
                                                  action: #selector(onTap(sender:)))
        return onTapGesture
    }()

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
    }

    func addTabbarItem(item: TabbarItem) {
        let controller = item.controller
        tabbarView.tabbarItems.append(item)
        tabbarView.tabbarItems.last!.itemView.addGestureRecognizer(onTapGesture)
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
            tabbarView.currentItemIndex = senderView.indexInTabbar
        }
        print("clicked")
    }
}

