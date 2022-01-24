//
//  TabbarController.swift
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
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let itemNameLabel: UILabel = {
       
        let itemNameLabel = UILabel()
        itemNameLabel.backgroundColor = .clear
        
        return itemNameLabel
        
    }()
    
    var icon: UIImage? = nil {
        didSet {
            imageView.image = icon
        }
    }
    
    var itemName: String? = nil {
        didSet {
            
        }
    }
    
    init(icon: UIImage, itemName: String) {
        super.init(frame: .zero)
        self.icon = icon
        self.itemName = itemName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(imageView)
        addSubview(itemNameLabel)
    }
    
    private func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
        }
        itemNameLabel.snp.makeConstraints { make in
            
        }
    }
}

class TabbarItem {
    var itemView: TabbarItemView!
    var controller: UIViewController!
}

class TabbarView: UIView {
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
