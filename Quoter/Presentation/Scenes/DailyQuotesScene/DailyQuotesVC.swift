//
//  RedVC.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//
import UIKit

final class DailyQuotesVC: BaseVC {
    
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
