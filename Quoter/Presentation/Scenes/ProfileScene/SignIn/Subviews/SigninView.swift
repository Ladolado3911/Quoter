//
//  SigninView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

class SigninView: UIView {

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = DarkModeColors.white
        titleLabel.text = "Sign in"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(DarkModeColors.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let formView: FormView = {
        let formView = FormView(formType: .signIn)
        formView.translatesAutoresizingMaskIntoConstraints = false
        return formView
    }()
    
    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = DarkModeColors.white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let thirdPartyButtonView1: ThirdPartyButtonView = {
        let buttonView = ThirdPartyButtonView(buttonType: .google)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView
    }()
    
    let thirdPartyButtonView2: ThirdPartyButtonView = {
        let buttonView = ThirdPartyButtonView(buttonType: .apple)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(signUpButton)
        addSubview(formView)
        addSubview(separatorLineView)
        addSubview(thirdPartyButtonView1)
        addSubview(thirdPartyButtonView2)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: formView.topAnchor, constant: -bounds.height * 0.05),
            
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signUpButton.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            
            formView.centerXAnchor.constraint(equalTo: centerXAnchor),
            formView.centerYAnchor.constraint(equalTo: centerYAnchor),
            formView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7656),
            formView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2852),
            
            separatorLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.875),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.topAnchor.constraint(equalTo: formView.bottomAnchor, constant: bounds.height * 0.05),
            
            thirdPartyButtonView1.centerXAnchor.constraint(equalTo: centerXAnchor),
            thirdPartyButtonView1.widthAnchor.constraint(equalTo: formView.widthAnchor),
            thirdPartyButtonView1.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: bounds.height * 0.05),
            thirdPartyButtonView1.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
            thirdPartyButtonView2.centerXAnchor.constraint(equalTo: centerXAnchor),
            thirdPartyButtonView2.widthAnchor.constraint(equalTo: formView.widthAnchor),
            thirdPartyButtonView2.heightAnchor.constraint(equalTo: thirdPartyButtonView1.heightAnchor),
            thirdPartyButtonView2.topAnchor.constraint(equalTo: thirdPartyButtonView1.bottomAnchor, constant: 15),
            //thirdPartyButtonView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
            
        ])
    }
}
