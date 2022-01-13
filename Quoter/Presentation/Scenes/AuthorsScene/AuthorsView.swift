//
//  AuthorsView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/13/22.
//

import UIKit
import SnapKit

class AuthorsView: UIView {
    
    lazy var mainImageView: UIImageView = {
        let width = PublicConstants.screenWidth
        let height = PublicConstants.screenHeight * 0.732
        let x: CGFloat = 0
        let y: CGFloat = 0
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let imgView = UIImageView(frame: frame)
        imgView.image = UIImage(named: "milne")
        imgView.contentMode = .scaleAspectFill
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [
            UIColor.black.withAlphaComponent(1).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 0.5, 1]

        imgView.layer.addSublayer(gradient)
        return imgView
    }()
    
    let quoterNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let authorsContentView: AuthorsContentView = {
        let contentView = AuthorsContentView()
        return contentView
    }()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(quoterNameLabel)
        addSubview(authorsContentView)
    }
    
    private func buildConstraints() {
//        quoterNameLabel.snp.makeConstraints { make in
//
//        }
        authorsContentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(PublicConstants.screenHeight * 0.382)
        }
    }
}