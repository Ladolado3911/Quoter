//
//  MenuController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuVC: BaseVC {
    
    lazy var menuAppearTransform = CGAffineTransform(translationX: view.bounds.width * 0.521875, y: 0)
    
    var selectedItemIndex: Int = 0
    var selectedVC: UIViewController {
        MenuModels.shared.menuItems[selectedItemIndex].viewController
    }
    
    lazy var menuView: MenuView = {
        let width = view.bounds.width * 0.521875
        let frame = CGRect(x: -width, y: 0, width: width, height: view.bounds.height)
        let view = MenuView(frame: frame)
        return view
    }()
    
    let menuVCButton: UIButton = {
        let menuButton = UIButton()
        menuButton.setImage(MenuIcons.menuIcon, for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buildSubviews()
        buildConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        if let firstItem = MenuModels.shared.menuItems.first {
            addChild(firstItem.viewController)
            view.addSubview(firstItem.viewController.view)
        }
        menuVCButton.addTarget(self, action: #selector(didTapOnMenuVCButton(sender:)), for: .touchUpInside)
        bringSubviewsToFront()
    }
    
    private func bringSubviewsToFront() {
        view.bringSubviewToFront(statusRectView)
        view.bringSubviewToFront(menuView)
    }
    
    private func buildSubviews() {
        view.addSubview(menuView)
        view.addSubview(menuVCButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            menuVCButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuVCButton.topAnchor.constraint(equalTo: statusRectView.bottomAnchor, constant: 20),
            menuVCButton.widthAnchor.constraint(equalToConstant: 35),
            menuVCButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    @objc func didTapOnMenuVCButton(sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.menuView.transform = self.menuView.transform == .identity ? self.menuAppearTransform : .identity
        }
        UIView.animate(withDuration: 0.2, delay: 0) {[weak self] in
            guard let self = self else { return }
            self.selectedVC.view.transform = self.selectedVC.view.transform == .identity ? self.menuAppearTransform : .identity
        }
        UIView.animate(withDuration: 0.2, delay: 0) {[weak self] in
            guard let self = self else { return }
            self.menuVCButton.transform = self.menuVCButton.transform == .identity ? self.menuAppearTransform : .identity
        }
    }
    
    
}
