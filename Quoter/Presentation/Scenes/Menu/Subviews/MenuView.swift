//
//  MenuView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

final class MenuView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = false
        table.backgroundColor = DarkModeColors.mainBlack
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(tableView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        ])
    }
}
