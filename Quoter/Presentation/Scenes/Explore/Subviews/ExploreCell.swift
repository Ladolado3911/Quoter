//
//  ExploreCell.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        //let frame = CGRect(x: 0, y: 44, width: bounds.width, height: bounds.height * 0.8)
        gradient.frame = bounds
        gradient.colors = [DarkModeColors.black.cgColor, UIColor.clear.cgColor, DarkModeColors.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0, 0.6161, 1]
        return gradient
    }()
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.addSublayer(gradientLayer)
        return imageView
    }()

    let quoteButtonView: QuoteButtonView = {
        let quoteButtonView = QuoteButtonView()
        quoteButtonView.translatesAutoresizingMaskIntoConstraints = false
        return quoteButtonView
    }()
    
    let authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.textColor = DarkModeColors.white
        authorNameLabel.textAlignment = .center
        authorNameLabel.font = Fonts.businessFonts.libreBaskerville.bold(size: 20)
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorNameLabel
    }()
    
    let quoteContentLabel: UILabel = {
        // 55 char is max
        let quoteContentLabel = UILabel()
        quoteContentLabel.numberOfLines = 2
        quoteContentLabel.addLineHeight(lineHeight: Constants.screenHeight * 0.04)
        quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: 23)
        quoteContentLabel.textColor = .white
        quoteContentLabel.textAlignment = .center
        quoteContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return quoteContentLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        startAnimating()
        buildSubviews()
        buildConstraints()
    }
    
    func startAnimating() {
        createAndStartLoadingLottieAnimation(animation: .dots,
                                             animationSpeed: 1,
                                             frame: CGRect(x: bounds.width / 2 - 150,
                                                           y: bounds.height / 2 - 150,
                                                           width: 300,
                                                           height: 300),
                                             loopMode: .loop,
                                             contentMode: .scaleAspectFill,
                                             completion: nil)
    }
    
    func stopAnimating() {
        stopLoadingLottieAnimationIfExists()
    }
    
    private func buildSubviews() {
        addSubview(imgView)
        addSubview(authorNameLabel)
        addSubview(quoteContentLabel)
        addSubview(quoteButtonView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            quoteContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.0352),
            quoteContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quoteContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quoteContentLabel.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.1232),
            
            authorNameLabel.bottomAnchor.constraint(equalTo: quoteContentLabel.topAnchor, constant: -Constants.screenHeight * 0.0352),
            authorNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            authorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            authorNameLabel.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0352),
            
            quoteButtonView.bottomAnchor.constraint(equalTo: authorNameLabel.topAnchor, constant: -Constants.screenHeight * 0.0088),
            quoteButtonView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonView.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
