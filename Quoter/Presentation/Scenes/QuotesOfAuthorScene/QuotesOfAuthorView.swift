//
//  QuotesOfAuthorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit
import SnapKit

class QuotesOfAuthorView: UIView {
    
    var state: QuotesOfAuthorVCState = .coreData {
        didSet {
            layoutSubviews()
        }
    }
    
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
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    lazy var ideaButton: UIButton = {
        let button = UIButton(type: .custom)
        switch state {
        case .network:
            button.setImage(UIImage(named: "IdeaOff"), for: .normal)
            button.setImage(UIImage(named: "IdeaOn"), for: .selected)
        case .coreData:
            button.setImage(UIImage(named: "Waste"), for: .normal)
            
        }
        return button
    }()
    
    let quoteTextView: UILabel = {
        let quoteTextView = UILabel()
        let font = UIFont(name: "Kalam-Regular", size: 30)
        quoteTextView.backgroundColor = .clear
        quoteTextView.textColor = .white
        quoteTextView.font = font
        quoteTextView.textAlignment = .center
        quoteTextView.numberOfLines = 6
        return quoteTextView
    }()
    
    let nextButton: SwitchButton = {
        let nextButton = SwitchButton(type: .custom)
        nextButton.setTitle("Next", for: .normal)
        return nextButton
    }()
    
    let prevButton: SwitchButton = {
        let prevButton = SwitchButton(type: .custom)
        prevButton.setTitle("Previous", for: .normal)
        return prevButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(darkView)
        addSubview(closeButton)
        addSubview(titleOfAuthor)
        addSubview(ideaButton)
        addSubview(quoteTextView)
        addSubview(nextButton)
        addSubview(prevButton)
        quoteTextView.numberOfLines = 15
        let fontSize = getFontSizeForQuote(stringCount: CGFloat(quoteTextView.text?.count ?? 0))
        quoteTextView.font = quoteTextView.font?.withSize(fontSize)
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
            make.top.equalTo(self).inset(70)
        }
        titleOfAuthor.snp.makeConstraints { make in
            make.left.equalTo(closeButton.snp.right).inset(-20)
            make.right.equalTo(ideaButton.snp.left).inset(-20)
            make.bottom.equalTo(quoteTextView.snp.top)
        }
        ideaButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(20)
            make.centerY.equalTo(closeButton)
            make.width.height.equalTo(PublicConstants.screenHeight * 0.0968)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
            //make.centerY.equalTo(self)
            make.bottom.equalTo(prevButton.snp.top).inset(-10)
            make.height.equalTo(PublicConstants.screenHeight * 0.3521126)
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
    
    private func getFontSizeForQuote(stringCount: CGFloat) -> CGFloat {
        let lowerBound: CGFloat = PublicConstants.screenHeight * 0.02159827213822894
        let higherBound: CGFloat = PublicConstants.screenHeight * 0.05399568034557235
        let boundRange = higherBound - lowerBound
        let testResult = lowerBound + ((1 / (stringCount / 35)) * boundRange)
        return testResult
    }
}

class SwitchButton: UIButton {
    
    var isButtonEnabled: Bool = false {
        didSet {
            if isButtonEnabled != oldValue {
                if isButtonEnabled {
                    enableButton()
                }
                else {
                    disableButton()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 3
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        
        switch isButtonEnabled {
        case true:
            enableButton()
        case false:
            disableButton()
        }
    }
    
    private func enableButton() {
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        isUserInteractionEnabled = true
    }
    
    private func disableButton() {
        backgroundColor = .gray
        setTitleColor(.white, for: .normal)
        isUserInteractionEnabled = false
    }
}
