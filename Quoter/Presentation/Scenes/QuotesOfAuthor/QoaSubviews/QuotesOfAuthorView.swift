//
//  QuotesOfAuthorView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/1/22.
//

import UIKit
import SnapKit

class QuotesOfAuthorView: LottieView {
    
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
    
//    lazy var gradient: CAGradientLayer = {
//        let gradient = CAGradientLayer()
//        gradient.type = .radial
//        gradient.colors = [
//            UIColor.black.withAlphaComponent(0.8).cgColor,
//            UIColor.clear.cgColor,
//        ]
//        gradient.locations = [0, 1]
//        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.2, y: 0.9)
//        return gradient
//    }()
    
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
    
    lazy var switchButton: UIButton = {
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
        backgroundColor = .black
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainImageView)
        addSubview(darkView)
        addSubview(closeButton)
        addSubview(titleOfAuthor)
        addSubview(switchButton)
        addSubview(quoteTextView)
        addSubview(nextButton)
        addSubview(prevButton)
//        layer.addSublayer(gradient)
//        gradient.frame = bounds
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
            make.left.right.equalTo(self).inset(20)
            make.bottom.equalTo(quoteTextView.snp.top)
        }
        switchButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(20)
            make.centerY.equalTo(closeButton)
            make.width.height.equalTo(PublicConstants.screenHeight * 0.0968)
        }
        quoteTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(20)
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
    
    func startAnimating() {
        let size = bounds.width / 3.5
        let x = bounds.width / 2 - (size / 2)
        let y = bounds.height / 2 - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        createAndStartLottieAnimation(animation: .circleLoading,
                                      animationSpeed: 1,
                                      frame: frame,
                                      loopMode: .loop,
                                      contentMode: .scaleAspectFit,
                                      completion: nil)
    }
    
    private func getFontSizeForQuote(stringCount: CGFloat) -> CGFloat {
        let lowerBound: CGFloat = PublicConstants.screenHeight * 0.02159827213822894
        let higherBound: CGFloat = PublicConstants.screenHeight * 0.05399568034557235
        let boundRange = higherBound - lowerBound
        let testResult = lowerBound + ((1 / (stringCount / 35)) * boundRange)
        return testResult
    }
}
