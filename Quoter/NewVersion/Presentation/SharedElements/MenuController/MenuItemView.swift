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
    }
    
    private func buildConstraints() {
        
    }

}
