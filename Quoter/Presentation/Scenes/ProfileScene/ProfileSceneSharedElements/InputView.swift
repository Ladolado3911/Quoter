//
//  InputView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

enum InputViewType {
    case password
    case email
}

class InputView: UIView {
    
    let inputViewTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DarkModeColors.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rectView: UIView = {
        let rectView = UIView()
        rectView.backgroundColor = DarkModeColors.lightBlack
        rectView.layer.applySketchShadow(color: DarkModeColors.black,
                                         alpha: 0.35,
                                         x: 1,
                                         y: 2,
                                         blur: 4,
                                         spread: 0)
        rectView.layer.cornerRadius = 10
        rectView.translatesAutoresizingMaskIntoConstraints = false
        return rectView
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = DarkModeColors.white
        textField.textAlignment = .left
        textField.clearsOnBeginEditing = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(type: InputViewType) {
        self.init(frame: .zero)
        switch type {
        case .password:
            inputViewTitleLabel.text = "Password"
        case .email:
            inputViewTitleLabel.text = "Email"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(rectView)
        addSubview(inputViewTitleLabel)
        addSubview(inputTextField)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            inputViewTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            inputViewTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputViewTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputViewTitleLabel.bottomAnchor.constraint(equalTo: rectView.topAnchor),
            
            rectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rectView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.605),
            
            inputTextField.leadingAnchor.constraint(equalTo: rectView.leadingAnchor, constant: 10),
            inputTextField.topAnchor.constraint(equalTo: rectView.topAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: rectView.trailingAnchor, constant: -10),
            inputTextField.bottomAnchor.constraint(equalTo: rectView.bottomAnchor),
            
            
        
        ])
    }
}
