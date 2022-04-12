//
//  TabbarItemView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 1/24/22.
//

import UIKit
import SnapKit

//enum TabbarItemViewState {
//    case on
//    case off
//}

class TabbarItemView: UIView {
    
    var indexInTabbar: Int = 0
    
    var state: State = .off {
        didSet {
            if state != oldValue {
                let origImage = imageView.image
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                imageView.image = nil
                imageView.image = tintedImage
                switch state {
                case .on:
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let self = self else { return }
                        self.itemNameLabel.textColor = .white
                        self.imageView.tintColor = .white
                    }
                case .off:
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let self = self else { return }
                        self.itemNameLabel.textColor = .black
                        self.imageView.tintColor = .black
                    }
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
        return itemNameLabel
    }()
    
    var icon: UIImage? = nil {
        didSet {
            imageView.image = icon
        }
    }
    
    var itemName: String? = nil {
        didSet {
            itemNameLabel.text = itemName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(icon: UIImage, itemName: String) {
        self.init(frame: .zero)
        self.imageView.image = icon
        self.itemNameLabel.text = itemName
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
