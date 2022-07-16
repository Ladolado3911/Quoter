//
//  GalleryQuoteView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/16/22.
//

import UIKit



class GalleryQuoteView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let quotieLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoIcon"))
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
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
    
    let authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.textColor = DarkModeColors.white
        authorNameLabel.textAlignment = .center
        authorNameLabel.font = Fonts.businessFonts.libreBaskerville.bold(size: Constants.screenHeight * 0.027)
        authorNameLabel.alpha = 0
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorNameLabel
    }()
    
    let quoteContentLabel: UILabel = {
        // 55 char is max
        let quoteContentLabel = UILabel()
        quoteContentLabel.numberOfLines = 2
        quoteContentLabel.addLineHeight(lineHeight: Constants.screenHeight * 0.043)
        quoteContentLabel.textColor = .white
        quoteContentLabel.textAlignment = .center
        quoteContentLabel.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        quoteContentLabel.alpha = 0
        quoteContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return quoteContentLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //setData()
        //backgroundColor = DarkModeColors
        layer.masksToBounds = true
        layer.cornerRadius = 30
        //layer.borderWidth = 1
        layer.borderColor = DarkModeColors.white.cgColor
        buildSubviews()
        buildConstraints()
        
    }
//
//    private func setData() {
//        if let exploreCell = exploreCell {
//            quoteContentLabel.text = exploreCell.quoteContentLabel.text
//            quoteContentLabel.font = exploreCell.quoteContentLabel.font
//            authorNameLabel.text = exploreCell.authorNameLabel.text
//            imgView.image = exploreCell.imgView.image
//        }
//    }
    
    private func buildSubviews() {
        addSubview(imgView)
        addSubview(closeButton)
        addSubview(authorNameLabel)
        addSubview(quoteContentLabel)
        addSubview(quotieLogoImageView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            quoteContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.04),
            quoteContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quoteContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quoteContentLabel.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.1232),
            
            authorNameLabel.bottomAnchor.constraint(equalTo: quoteContentLabel.topAnchor, constant: -Constants.screenHeight * 0.0352),
            authorNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            authorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            authorNameLabel.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.037),
            
            quotieLogoImageView.bottomAnchor.constraint(equalTo: authorNameLabel.topAnchor, constant: -Constants.screenHeight * 0.0088),
            quotieLogoImageView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quotieLogoImageView.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quotieLogoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            closeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.07),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }
}
