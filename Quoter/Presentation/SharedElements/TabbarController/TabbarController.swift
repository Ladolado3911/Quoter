//
//  TabbarController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/25/22.
//

import UIKit
import Combine
import AVFAudio
import AVFoundation
import Firebase


class TabbarController: UIViewController {
    
    let tabbarItemsSubject = PassthroughSubject<TabbarItem, Never>()
    var cancellables: Set<AnyCancellable> = []
    
    var prevIndex: Int?
    
    let arr = Sound.allCases.filter({ $0.rawValue.contains("music") })

    var tabbarView: TabbarView = TabbarView()

    let musicIconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "musicOff"), for: .normal)
        button.setImage(UIImage(named: "musicOn"), for: .selected)
        return button
    }()
    
    let bellIconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: "Alarm"), for: .normal)
        return button
    }()
    
    var currentPlayer: AVAudioPlayer?
    
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
        view.addSubview(bellIconButton)
        //currentPlayer?.delegate = self
        musicIconButton.addTarget(self, action: #selector(onMusicIcon(sender:)), for: .touchUpInside)
        bellIconButton.addTarget(self, action: #selector(onBellIcon(sender:)), for: .touchUpInside)

        tabbarView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(20)
            make.height.equalTo(PublicConstants.screenHeight * 0.0739)
        }
        musicIconButton.snp.makeConstraints { make in
            make.top.equalTo(bellIconButton.snp.bottom).inset(-10)
            make.right.equalTo(bellIconButton)
            make.width.height.equalTo(PublicConstants.screenHeight * 0.06)
        }
        bellIconButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(PublicConstants.screenHeight * 0.11267)
            make.right.equalTo(view).inset(20)
            make.width.height.equalTo(musicIconButton)
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
        view.bringSubviewToFront(bellIconButton)
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
            Analytics.logEvent("switch_tabbar", parameters: nil)
            let arr = tabbarView.tabbarItems
            removeChildController(controller: arr[tabbarView.currentItemIndex].controller)
            addChildController(controller: arr[senderView.indexInTabbar].controller)
            tabbarView.currentItemIndex = senderView.indexInTabbar
        }
    }
    
    @objc func onMusicIcon(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        Analytics.logEvent("did_tap_on_music", parameters: nil)
        sender.isSelected = !sender.isSelected
        let optionalMusic = arr.uniqueRandomElement(isEnabling: sender.isSelected)
        if let currentPlayer1 = currentPlayer {
            currentPlayer = nil
            currentPlayer1.stop()
        }
        else {
            optionalMusic?.play(extensionString: .mp3)
            optionalMusic?.player?.delegate = self
            currentPlayer = optionalMusic?.player
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.isUserInteractionEnabled = true
        }
    }
    
    @objc func onBellIcon(sender: UIButton) {
        let vc = NotificationVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
}

extension TabbarController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Analytics.logEvent("audio_switched_while_playing", parameters: nil)
        if musicIconButton.isSelected && flag {
            let optionalMusic = arr.uniqueRandomElement(isEnabling: true)
            optionalMusic?.play(extensionString: .mp3)
            optionalMusic?.player?.delegate = self
            currentPlayer = optionalMusic?.player
            currentPlayer?.play()
        }
        
    }
}

