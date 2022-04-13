//
//  BaseVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/13/22.
//

import UIKit

class BaseVC: UIViewController {
    
    let statusRectView: UIView = {
        let view = UIView()
        view.backgroundColor = DarkModeColors.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(statusRectView)
        NSLayoutConstraint.activate([
            statusRectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusRectView.topAnchor.constraint(equalTo: view.topAnchor),
            statusRectView.widthAnchor.constraint(equalTo: view.widthAnchor),
            statusRectView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.06514)
        ])
    }
}
