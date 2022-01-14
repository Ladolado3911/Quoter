//
//  AuthorCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/14/22.
//

import UIKit

class AuthorCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
    }
}
