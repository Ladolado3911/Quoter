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
        //imgView.backgroundColor = UIColor.randomColor()
        return imgView
    }()
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.backgroundColor = .black.withAlphaComponent(0.65)
        return darkView
    }()
    
    let quoteTextView: UITextView = {
        let quoteTextView = UITextView()
        quoteTextView.isEditable = false
        quoteTextView.isSelectable = false
        quoteTextView.backgroundColor = .clear
        quoteTextView.textColor = .blue
        return quoteTextView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(darkView)
        addSubview(quoteTextView)
    }
    
    private func buildConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        darkView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(36)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.519)
            make.bottom.equalTo(self).inset(100)
        }
    }
}
