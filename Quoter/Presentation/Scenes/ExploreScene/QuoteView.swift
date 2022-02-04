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
        return imgView
    }()
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.backgroundColor = .black.withAlphaComponent(0.6)
        return darkView
    }()
    
    let ideaImageView: IdeaImageView = {
        let ideaView = IdeaImageView()
        ideaView.contentMode = .scaleAspectFill
        return ideaView
    }()
    
    let bookImageView: BookImageView = {
        let bookView = BookImageView()
        bookView.contentMode = .scaleAspectFill
        return bookView
    }()
    
    let quoteTextView: UILabel = {
        let quoteTextView = UILabel()
        let font = UIFont(name: "Kalam-Regular", size: 35)
        //font?.lineHeight = 30
//        quoteTextView.isEditable = false
//        quoteTextView.isSelectable = false
        quoteTextView.backgroundColor = .clear
        quoteTextView.textColor = .white
        quoteTextView.font = font
        quoteTextView.textAlignment = .center
        quoteTextView.numberOfLines = 4
        return quoteTextView
    }()
    
    let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.backgroundColor = .clear
        authorLabel.textColor = .white
        authorLabel.textAlignment = .center
        authorLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        return authorLabel
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
        addSubview(authorLabel)
        addSubview(ideaImageView)
        addSubview(bookImageView)
    }
    
    private func buildConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        darkView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        ideaImageView.snp.makeConstraints { make in
            make.left.equalTo(self).inset(20)
            make.width.height.equalTo(PublicConstants.screenHeight * 0.0968)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.11267)
        }
        bookImageView.snp.makeConstraints { make in
            make.left.equalTo(ideaImageView)
            make.width.equalTo(ideaImageView)
            make.top.equalTo(ideaImageView.snp.bottom).inset(-PublicConstants.screenHeight * 0.026408)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
            //make.centerY.equalTo(self)
            make.bottom.equalTo(authorLabel.snp.top).inset(-PublicConstants.screenHeight * 0.0774)
        }
        authorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            //make.top.equalTo(quoteTextView.snp.bottom).inset(-40)
            make.bottom.equalTo(self).inset(PublicConstants.screenHeight * 0.176)
        }
    }
}
