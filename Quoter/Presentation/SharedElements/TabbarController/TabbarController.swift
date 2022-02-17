//
//  TabbarController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/25/22.
//

import UIKit
import Combine
import AVFAudio


class TabbarController: UIViewController {
    
    let tabbarItemsSubject = PassthroughSubject<TabbarItem, Never>()
    var cancellables: Set<AnyCancellable> = []
    
    var prevIndex: Int?
    
    var tabbarView: TabbarView = TabbarView()

    let musicIconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "musicOff"), for: .normal)
        button.setImage(UIImage(named: "musicOn"), for: .selected)
        return button
    }()
    
    var player: AVAudioPlayer?
    
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
        view.addSubview(musicIconButton)
        musicIconButton.addTarget(self, action: #selector(onMusicIcon(sender:)), for: .touchUpInside)

        tabbarView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(20)
            make.height.equalTo(PublicConstants.screenHeight * 0.0739)
        }
        musicIconButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(PublicConstants.screenHeight * 0.11267)
            make.right.equalTo(view).inset(20)
            make.width.height.equalTo(50)
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
        view.bringSubviewToFront(musicIconButton)
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
    
    @objc func onMusicIcon(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let player = Sound.music1.player,
           player.isPlaying {
            player.stop()
        }
        else {
            Sound.music1.play(extensionString: .mp3)
        }
    }
}

