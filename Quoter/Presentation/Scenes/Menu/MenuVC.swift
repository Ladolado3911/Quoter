//
//  MenuController.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

enum MenuViewVisibility {
    case visible
    case invisible
}

class TapOnBlurGesture: UITapGestureRecognizer {
    
}

class MenuVC: UIViewController {
    
    lazy var menuAppearTransform = CGAffineTransform(translationX: view.bounds.width * 0.521875, y: 0)
    lazy var tapGesture = TapOnBlurGesture(target: self, action: #selector(didTapOnVCGesture(sender:)))
    lazy var leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeftOnMenuView(sender:)))
    
    var selectedItemIndex: Int = 0
    let viewControllers = MenuModels.shared.menuItems.map { $0.viewController }
    var menuItems = MenuModels.shared.menuItems
    var selectedVC: UIViewController {
        viewControllers[selectedItemIndex]
    }
    var isMenuVisible: MenuViewVisibility = .invisible

    lazy var menuView: MenuView = {
        let width = view.bounds.width * 0.521875
        let frame = CGRect(x: -width, y: 0, width: width, height: view.bounds.height)
        let view = MenuView(frame: frame)
        return view
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.alpha = 0
        return blurView
    }()
    
    let menuVCButton: UIButton = {
        let menuButton = UIButton()
        menuButton.setImage(MenuIcons.menuIcon.resizedImage(targetHeight: Constants.screenHeight * 0.06), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buildSubviews()
        buildConstraints()
    }

    private func setup() {
        leftSwipeRecognizer.direction = .left
        menuView.addGestureRecognizer(leftSwipeRecognizer)
        blurEffectView.addGestureRecognizer(tapGesture)
        for childIndex in 0..<MenuModels.shared.menuItems.count {
            let vc = MenuModels.shared.menuItems[childIndex].viewController
            addChild(vc)
            if childIndex == 0 {
                view.addSubview(vc.view)
            }
        }
        menuVCButton.addTarget(self, action: #selector(didTapOnMenuVCButton(sender:)), for: .touchUpInside)
        bringSubviewsToFront()
        configTableView()
    }
    
    private func switchVC(index: Int) {
        for subview in view.subviews {
            if !(subview is MenuView || subview is UIButton || subview is StatusRectView || subview is UIVisualEffectView) {
                subview.removeFromSuperview()
            }
        }
        selectedItemIndex = index
        selectedVC.view.transform = menuAppearTransform
        view.addSubview(selectedVC.view)
        view.sendSubviewToBack(selectedVC.view)
    }
    
    private func configTableView() {
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
        menuView.tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        menuView.tableView.register(MenuHeaderView.self, forHeaderFooterViewReuseIdentifier: "MenuHeader")
    }
    
    private func bringSubviewsToFront() {
        //view.bringSubviewToFront(statusRectView)
        view.bringSubviewToFront(menuView)
        view.bringSubviewToFront(menuVCButton)
    }
    
    private func buildSubviews() {
        view.addSubview(menuView)
        view.addSubview(blurEffectView)
        view.addSubview(menuVCButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            menuVCButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.screenHeight * 0.04),
            menuVCButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.screenHeight * 0.07),
            menuVCButton.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.06),
            menuVCButton.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.06),
        ])
    }
    
    private func didTapOnVC() {
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
                self.blurEffectView.alpha = self.blurEffectView.alpha == 0 ? 1 : 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.blurEffectView.transform = self.blurEffectView.transform == .identity ? self.menuAppearTransform : .identity
            }
        }
    }
    
    @objc func didSwipeLeftOnMenuView(sender: UISwipeGestureRecognizer) {
        didTapOnVC()
    }
    
    @objc func didTapOnVCGesture(sender: UITapGestureRecognizer) {
        didTapOnVC()
    }
    
    @objc func didTapOnMenuVCButton(sender: UIButton) {
        didTapOnVC()
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MenuCell {
            cell.menuItem = menuItems[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeader")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.screenHeight * 0.176
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.screenHeight * 0.088
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for itemIndex in 0..<menuItems.count {
            menuItems[itemIndex].deselect()
        }
        menuItems[indexPath.row].select()
        switchVC(index: indexPath.row)
        tableView.reloadData()
        didTapOnVC()
    }
}
