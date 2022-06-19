//
//  TestVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit


class GalleryVC: BaseVC {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: view.bounds)
        label.text = "Coming Soon..."
        label.textColor = DarkModeColors.white
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DarkModeColors.mainBlack
        view.addSubview(titleLabel)
    }
    
}
