//
//  ExploreScreenshotView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/4/22.
//

import UIKit
//
//class ExploreScreenshotView: UIView {
//    
//    var exploreCollectionView: UICollectionView?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    convenience init(exploreCollectionView: UICollectionView, frame: CGRect) {
//        self.init(frame: frame)
//        self.exploreCollectionView = exploreCollectionView
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        buildSubviews()
//    }
//    
//    private func buildSubviews() {
//        if let exploreCollectionView = exploreCollectionView {
//            addSubview(exploreCollectionView)
//        }
//    }
//}

class ExploreScreenshotCell: UICollectionViewCell {
    var exploreCell: ExploreCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(exploreCell: ExploreCell, frame: CGRect) {
        self.init(frame: frame)
        self.exploreCell = exploreCell
    }
    
    let quotieLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoIcon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    
    let authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.textColor = DarkModeColors.white
        authorNameLabel.textAlignment = .center
        authorNameLabel.font = Fonts.businessFonts.libreBaskerville.bold(size: Constants.screenHeight * 0.027)
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorNameLabel
    }()
    
    let quoteContentLabel: UILabel = {
        // 55 char is max
        let quoteContentLabel = UILabel()
        quoteContentLabel.numberOfLines = 2
        quoteContentLabel.addLineHeight(lineHeight: Constants.screenHeight * 0.043)
        //quoteContentLabel.font = Fonts.businessFonts.libreBaskerville.regular(size: Constants.screenHeight * 0.02)
        quoteContentLabel.textColor = .white
        quoteContentLabel.textAlignment = .center
        quoteContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return quoteContentLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setData()
        buildSubviews()
        buildConstraints()
        
    }
    
    private func setData() {
        if let exploreCell = exploreCell {
            quoteContentLabel.text = exploreCell.quoteContentLabel.text
            quoteContentLabel.font = exploreCell.quoteContentLabel.font
            authorNameLabel.text = exploreCell.authorNameLabel.text
            imgView.image = exploreCell.imgView.image
        }
    }
    
    private func buildSubviews() {
        addSubview(imgView)
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
        ])
    }
}
