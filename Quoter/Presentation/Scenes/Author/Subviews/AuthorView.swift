//
//  AuthorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/15/22.
//

import UIKit

class AuthorView: UIView {
    
    let backButton: ArrowButton = {
        let button = ArrowButton(direction: .up, arrowIcon: FilterIcons.arrowDown)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backView: UIView = {
        let back = UIView()
        back.backgroundColor = DarkModeColors.lightBlack
        back.alpha = 0
        back.layer.cornerRadius = 25
        back.layer.applySketchShadow(color: DarkModeColors.black,
                                     alpha: 0.4,
                                     x: 1,
                                     y: 2,
                                     blur: 2,
                                     spread: 0)
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
//
//    let aboutLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let descLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(backView)
        addSubview(backButton)
        addSubview(tableView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.screenWidth * 0.078),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.screenHeight * 0.114),
            backButton.heightAnchor.constraint(equalToConstant: Constants.screenWidth * 0.1093),
            backButton.widthAnchor.constraint(equalToConstant: Constants.screenWidth * 0.1093),
            
            backView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backView.widthAnchor.constraint(equalToConstant: Constants.screenWidth * 0.928),
            backView.heightAnchor.constraint(equalToConstant: Constants.screenWidth * 0.1093 * 1.742),
            backView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: backView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}
