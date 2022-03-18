//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/19/22.
//

import UIKit

class QuoteView: LottieView {
    
    let mainImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let darkView: UIView = {
        let darkView = UIView()
        darkView.backgroundColor = .black.withAlphaComponent(0.6)
        return darkView
    }()

    let quotesOfAuthorButton: QuoteViewButton = {
        let bookView = QuoteViewButton(title: "More", icon: UIImage(named: "Reading")!)
        return bookView
    }()
    
    let filtersButton: QuoteViewButton = {
        let filterView = QuoteViewButton(title: "Tags", icon: UIImage(named: "filter")!)
        return filterView
    }()
    
    lazy var ideaButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "IdeaOff"), for: .normal)
        button.setImage(UIImage(named: "IdeaOn"), for: .selected)
        return button
    }()
    
    lazy var quoteTextView: UILabel = {
        let quoteTextView = UILabel()
        let font = UIFont(name: "Kalam-Regular", size: 35)
        //font?.lineHeight = 30
//        quoteTextView.isEditable = false
//        quoteTextView.isSelectable = false
        quoteTextView.backgroundColor = .clear
        quoteTextView.textColor = .white
        quoteTextView.font = font
        quoteTextView.textAlignment = .center
        quoteTextView.numberOfLines = 15
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

    let animationFrame: CGRect = {
        let size = PublicConstants.screenWidth / 3
        let x = PublicConstants.screenWidth / 2 - (size / 2)
        let y = PublicConstants.screenHeight / 2 - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        return frame
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
        addSubview(quotesOfAuthorButton)
        addSubview(filtersButton)
        addSubview(ideaButton)
    }

    private func buildConstraints() {
        mainImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        darkView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        quotesOfAuthorButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(20)
            make.width.equalTo(PublicConstants.screenHeight * 0.16)
            make.height.equalTo(PublicConstants.screenHeight * 0.045)
            make.top.equalTo(self).inset(PublicConstants.screenHeight * 0.11267)
        }
        filtersButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(20)
            make.width.equalTo(quotesOfAuthorButton)
            make.height.equalTo(quotesOfAuthorButton)
            make.top.equalTo(quotesOfAuthorButton.snp.bottom).inset(-15)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
            make.centerY.equalTo(self)
            make.height.equalTo(300)
        }
        authorLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(quoteTextView.snp.bottom).inset(-15)//inset(PublicConstants.screenHeight * 0.19)
            make.height.equalTo(20)
        }
        ideaButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(authorLabel.snp.bottom)
            make.bottom.equalTo(self).inset(PublicConstants.screenHeight * 0.0739 + 20)
            make.width.equalTo(PublicConstants.screenHeight * 0.0968)
        }
    }
}
