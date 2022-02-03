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
        return button
    }()
    
    let titleOfAuthor: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.backgroundColor = .clear
        title.font = UIFont(name: "Arial Rounded MT Bold", size: 24)
        title.textAlignment = .center
        return title
    }()
    
    let quoteTextView: UILabel = {
        let quoteTextView = UILabel()
        let font = UIFont(name: "Kalam-Regular", size: 30)
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
    
    let nextButton: SwitchButton = {
        let nextButton = SwitchButton(type: .custom)
        nextButton.setTitle("Next Quote", for: .normal)
        return nextButton
    }()
    
    let prevButton: SwitchButton = {
        let prevButton = SwitchButton(type: .custom)
        prevButton.setTitle("Previous Quote", for: .normal)
        return prevButton
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
        addSubview(titleOfAuthor)
        addSubview(quoteTextView)
        addSubview(nextButton)
        addSubview(prevButton)
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
        titleOfAuthor.snp.makeConstraints { make in
            make.left.right.equalTo(quoteTextView)
            make.bottom.equalTo(quoteTextView.snp.top).inset(-PublicConstants.screenHeight * 0.054577)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
            //make.centerY.equalTo(self)
            make.bottom.equalTo(nextButton.snp.top).inset(-PublicConstants.screenHeight * 0.2)
        }
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(PublicConstants.screenWidth * 0.03125)
            make.bottom.equalTo(prevButton)
            make.height.equalTo(prevButton)
            make.width.equalTo(PublicConstants.screenWidth * 0.3718)
        }
        prevButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(PublicConstants.screenWidth * 0.03125)
            make.bottom.equalTo(self).inset(PublicConstants.screenHeight * 0.05105)
            make.width.equalTo(PublicConstants.screenWidth * 0.4937)
            make.height.equalTo(PublicConstants.screenHeight * 0.0528)
        }
    }
}

class SwitchButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 3
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
    }
}
