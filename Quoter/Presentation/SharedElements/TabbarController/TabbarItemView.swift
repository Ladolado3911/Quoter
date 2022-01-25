//
//  TabbarItemView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/24/22.
//

import UIKit
import SnapKit

enum TabbarItemViewState {
    case on
    case off
}

class TabbarItemView: UIView {
    
    var state: TabbarItemViewState = .off {
        didSet {
            if state != oldValue {
                switch state {
                case .on:
                    itemNameLabel.textColor = .white
                case .off:
                    itemNameLabel.textColor = .black
                }
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let itemNameLabel: UILabel = {
        let itemNameLabel = UILabel()
        let font = UIFont(name: "Roboto-Bold", size: PublicConstants.screenHeight * 0.02288)
        itemNameLabel.backgroundColor = .clear
        itemNameLabel.textAlignment = .center
        itemNameLabel.textColor = .black
        itemNameLabel.text = "default"
        itemNameLabel.font = font
        itemNameLabel.adjustsFontForContentSizeCategory = true
        itemNameLabel.adjustsFontSizeToFitWidth = true
        //itemNameLabel.sizeToFit()
        return itemNameLabel
    }()
    
    var icon: UIImage? = nil {
        didSet {
            imageView.image = icon
            //layoutIfNeeded()
        }
    }
    
    var itemName: String? = nil {
        didSet {
            itemNameLabel.text = itemName
            //layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //sizeToFit()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
        addSubview(itemNameLabel)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.height.width.equalTo(bounds.width * 0.3)
        }
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
    }
}
