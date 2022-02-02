//
//  QuotesOfAuthorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit
import SnapKit

class QuotesOfAuthorView: UIView {
    
    let mainImageView: UIImageView = {
        let mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFill
        return mainImageView
    }()
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.backgroundColor = .black.withAlphaComponent(0.7)
        return darkView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(darkView)
        addSubview(closeButton)
    }
    
    private func buildConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self)
        }
        darkView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(mainImageView)
        }
        closeButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(20)
            make.width.height.equalTo(PublicConstants.screenHeight * 0.0968)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.11267)
        }
    }
}
