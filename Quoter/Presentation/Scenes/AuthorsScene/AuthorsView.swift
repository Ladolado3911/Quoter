//
//  AuthorsView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit

class AuthorsView: UIView {
    
    let statusView: StatusView = {
        let status = StatusView()
        status.backgroundColor = AppColors.mainColor
        //status.state = .small
        return status
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildInitialConstraints()
    }
    
    private func buildSubviews() {
        addSubview(statusView)
    }
    
    private func buildInitialConstraints() {
        statusView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            switch statusView.state {
            case .small:
                make.height.equalTo(44 + 55)
            case .large:
                make.height.equalTo(44 + 100)
            }
        }
    }
}
