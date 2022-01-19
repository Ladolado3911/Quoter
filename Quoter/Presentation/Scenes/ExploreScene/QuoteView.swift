//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class QuoteView: UIView {
    
    let mainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = UIColor.randomColor()
        return imgView
    }()
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.backgroundColor = .black.withAlphaComponent(0.65)
        return darkView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(darkView)
    }
    
    private func buildConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        darkView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
    }
}
