//
//  SignupView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//


import UIKit

class SignupView: UIView {

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = DarkModeColors.white
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
        let formView = FormView(formType: .signUp)
        formView.translatesAutoresizingMaskIntoConstraints = false
        return formView
    }()
    
    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = DarkModeColors.white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
//    let thirdPartyButtonView1: ThirdPartyButtonView = {
//        let buttonView = ThirdPartyButtonView(buttonType: .google)
//        buttonView.translatesAutoresizingMaskIntoConstraints = false
//        return buttonView
//    }()
//    
//    let thirdPartyButtonView2: ThirdPartyButtonView = {
//        let buttonView = ThirdPartyButtonView(buttonType: .apple)
//        buttonView.translatesAutoresizingMaskIntoConstraints = false
//        return buttonView
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(signUpButton)
        addSubview(formView)
        addSubview(separatorLineView)
//        addSubview(thirdPartyButtonView1)
//        addSubview(thirdPartyButtonView2)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signUpButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            formView.centerXAnchor.constraint(equalTo: centerXAnchor),
            formView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            formView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7656),
            
            separatorLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.875),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.topAnchor.constraint(equalTo: formView.bottomAnchor, constant: 30),
            
//            thirdPartyButtonView1.centerXAnchor.constraint(equalTo: centerXAnchor),
//            thirdPartyButtonView1.widthAnchor.constraint(equalTo: formView.widthAnchor),
//            thirdPartyButtonView1.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 20),
//            
//            thirdPartyButtonView2.centerXAnchor.constraint(equalTo: centerXAnchor),
//            thirdPartyButtonView2.widthAnchor.constraint(equalTo: formView.widthAnchor),
//            thirdPartyButtonView2.topAnchor.constraint(equalTo: thirdPartyButtonView1.bottomAnchor, constant: 15),
//            thirdPartyButtonView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
//            
        ])
    }
}
