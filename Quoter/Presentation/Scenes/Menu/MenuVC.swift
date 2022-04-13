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
    var selectedVC: BaseVC {
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
        configTableView()
    }
    
    private func configTableView() {
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
        menuView.tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
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
        let selectedVC = selectedVC
        UIView.animateKeyframes(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.menuView.transform = self.menuView.transform == .identity ? self.menuAppearTransform : .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                selectedVC.view.transform = selectedVC.view.transform == .identity ? self.menuAppearTransform : .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.menuVCButton.transform = self.menuVCButton.transform == .identity ? self.menuAppearTransform : .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                selectedVC.blurEffectView.alpha = selectedVC.blurEffectView.alpha == 0 ? 1 : 0
            }
        }
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuModels.shared.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MenuCell {
            cell.menuItem = MenuModels.shared.menuItems[indexPath.row]
        }
    }
}
