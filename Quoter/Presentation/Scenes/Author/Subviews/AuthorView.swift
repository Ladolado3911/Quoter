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
        table.alpha = 0
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textColor = DarkModeColors.white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: Constants.screenHeight * 0.021598272, weight: .bold)
        //label.font = LibreBaskerville.styles.defaultFont(size: backView.bounds.height / 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        addSubview(titleLabel)
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
            
            tableView.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: Constants.screenHeight * 0.0528),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
        ])
    }
}
