//
//  BaseVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

class StatusRectView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

class BaseVC: UIViewController {
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.alpha = 0
        return blurView
    }()
    
    let statusRectView: StatusRectView = {
        let view = StatusRectView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(statusRectView)
        view.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            statusRectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusRectView.topAnchor.constraint(equalTo: view.topAnchor),
            statusRectView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusRectView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.05)
        ])
    }
}
