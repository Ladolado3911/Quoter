//
//  MenuItemView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 4/12/22.
//

import UIKit

class MenuItemView: UIView {
    
    let titleField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, with item: MenuItem) {
        self.init(frame: frame)
        titleField.text = item.title
    }
    
    private func buildSubviews() {
        addSubview(titleField)
        addSubview(iconImageView)
    }
    
    private func buildConstraints() {
        
    }

}
