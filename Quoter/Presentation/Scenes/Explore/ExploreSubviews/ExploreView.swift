//
//  ExploreView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/2/22.
//

import UIKit
import AnimatedCollectionViewLayout

class ExploreView: LottieView {
    
    lazy var collectionView: UICollectionView = {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CrossFadeAttributesAnimator()
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let wifiLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap on wifi icon to reconnect"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont(name: "Arial", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.sizeToFit()
        return label
    }()
    
    let wifiButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "wifiOff"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(collectionView)
    }
    
    func addWifiButton() {
        collectionView.addSubview(wifiButton)
        collectionView.addSubview(wifiLabel)
        
        NSLayoutConstraint.activate([
            wifiButton.bottomAnchor.constraint(equalTo: wifiLabel.topAnchor, constant: -20),
            wifiButton.widthAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.1033),
            wifiButton.heightAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.1033),
            wifiButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            wifiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PublicConstants.screenHeight * 0.258264),
            wifiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            wifiLabel.heightAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.0517),
            wifiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            wifiLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        
        ])
    }
    
    func removeWifiButton() {
        wifiButton.removeFromSuperview()
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
    
    func stopAnimating() {
        //darkView.isHidden = false
        stopLottieAnimation()
    }
    
}
