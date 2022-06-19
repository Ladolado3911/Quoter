//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/15/22.
//

import UIKit

class ExploreView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = ExploreLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isPrefetchingEnabled = true
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()
    
    let leftArrowButton: ArrowButton = {
        let leftButton = ArrowButton(direction: .left, arrowIcon: ExploreIcons.arrowIconThin)
        leftButton.isEnabled = false
        return leftButton
    }()
    
    let rightArrowButton: ArrowButton = {
        let rightButton = ArrowButton(direction: .right, arrowIcon: ExploreIcons.arrowIconThin)
        rightButton.isEnabled = false
        return rightButton
    }()
    
    let downloadQuotePictureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(ExploreIcons.downloadIcon.resizedImage(targetHeight: Constants.screenHeight * 0.05), for: .normal)
        return button
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("General", for: .normal)
        button.setTitleColor(DarkModeColors.white, for: .normal)
        button.backgroundColor = DarkModeColors.black
        button.layer.borderWidth = 1
        button.layer.borderColor = DarkModeColors.white.cgColor
        button.titleLabel?.contentMode = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(Constants.screenHeight * 0.020)
        return button
    }()
    
    lazy var filterButtonCopy: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("General", for: .normal)
        button.setTitleColor(DarkModeColors.white, for: .normal)
        button.backgroundColor = DarkModeColors.black
        button.layer.borderWidth = 1
        button.layer.borderColor = DarkModeColors.white.cgColor
        button.titleLabel?.contentMode = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(Constants.screenHeight * 0.020)
        return button
    }()
    
    let quoteButtonView: QuoteButtonView = {
        let quoteButtonView = QuoteButtonView()
        quoteButtonView.translatesAutoresizingMaskIntoConstraints = false
        return quoteButtonView
    }()
    
    let quoteButtonViewCopy: QuoteButtonView = {
        let quoteButtonView = QuoteButtonView()
        quoteButtonView.translatesAutoresizingMaskIntoConstraints = false
        return quoteButtonView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    func animateQuoteButton() {
        UIView.animate(withDuration: 1, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.quoteButtonViewCopy.alpha = 0
            self.quoteButtonViewCopy.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.quoteButtonViewCopy.alpha = 1
                self.quoteButtonViewCopy.transform = .identity
            }
        }
    }

    func animateFilterButton() {
        UIView.animate(withDuration: 1.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.filterButtonCopy.alpha = 0
            self.filterButtonCopy.transform = CGAffineTransform(scaleX: 1.2, y: 1.4)
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.filterButtonCopy.alpha = 1
                self.filterButtonCopy.transform = .identity
            }
        }
    }
    
    private func buildSubviews() {
        addSubview(collectionView)
        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        addSubview(downloadQuotePictureButton)
        addSubview(filterButtonCopy)
        addSubview(filterButton)
        addSubview(quoteButtonViewCopy)
        addSubview(quoteButtonView)
        bringSubviewToFront(leftArrowButton)
        bringSubviewToFront(rightArrowButton)
        bringSubviewToFront(downloadQuotePictureButton)
        bringSubviewToFront(filterButtonCopy)
        bringSubviewToFront(filterButton)
        bringSubviewToFront(quoteButtonViewCopy)
        bringSubviewToFront(quoteButtonView)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            leftArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftArrowButton.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.11619),
            leftArrowButton.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.11619),
            leftArrowButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.screenHeight * 0.60563),
            
            rightArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightArrowButton.widthAnchor.constraint(equalTo: leftArrowButton.widthAnchor),
            rightArrowButton.heightAnchor.constraint(equalTo: leftArrowButton.heightAnchor),
            rightArrowButton.centerYAnchor.constraint(equalTo: leftArrowButton.centerYAnchor),
            
            downloadQuotePictureButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.screenHeight * 0.072),
            downloadQuotePictureButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.screenHeight * 0.01),
            downloadQuotePictureButton.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.06),
            downloadQuotePictureButton.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.06),
            
            filterButton.trailingAnchor.constraint(equalTo: downloadQuotePictureButton.leadingAnchor, constant: -Constants.screenHeight * 0.01),
            filterButton.centerYAnchor.constraint(equalTo: downloadQuotePictureButton.centerYAnchor),
            filterButton.heightAnchor.constraint(equalTo: downloadQuotePictureButton.heightAnchor, multiplier: 0.6),
            filterButton.widthAnchor.constraint(equalTo: downloadQuotePictureButton.heightAnchor, multiplier: 2),
            
            filterButtonCopy.trailingAnchor.constraint(equalTo: downloadQuotePictureButton.leadingAnchor, constant: -Constants.screenHeight * 0.01),
            filterButtonCopy.centerYAnchor.constraint(equalTo: downloadQuotePictureButton.centerYAnchor),
            filterButtonCopy.heightAnchor.constraint(equalTo: downloadQuotePictureButton.heightAnchor, multiplier: 0.6),
            filterButtonCopy.widthAnchor.constraint(equalTo: downloadQuotePictureButton.heightAnchor, multiplier: 2),
            
            quoteButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.245),
            quoteButtonView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonView.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            quoteButtonViewCopy.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.screenHeight * 0.245),
            quoteButtonViewCopy.heightAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonViewCopy.widthAnchor.constraint(equalToConstant: Constants.screenHeight * 0.0528),
            quoteButtonViewCopy.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        filterButtonCopy.layer.cornerRadius = filterButton.bounds.height * 0.4347
        filterButton.layer.cornerRadius = filterButton.bounds.height * 0.4347
    }
    
    func startAnimating() {
        createAndStartLoadingLottieAnimation(animation: .wakeup,
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
}
