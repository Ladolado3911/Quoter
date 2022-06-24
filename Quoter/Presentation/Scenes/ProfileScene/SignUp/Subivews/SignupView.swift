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
        titleLabel.text = "Sign up"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let formView: FormView = {
        let formView = FormView(formType: .signUp)
        formView.translatesAutoresizingMaskIntoConstraints = false
        return formView
    }()
    
    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = DarkModeColors.white
        //lineView.alpha = 0
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let verificationView: InputView = {
        let inputView = InputView(type: .verification)
        //inputView.alpha = 0
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    let verifyButton: CallToActionButton = {
        let button = CallToActionButton()
        button.callToActionButtonType = .verification
        //button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        backgroundColor = DarkModeColors.mainBlack
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        addSubview(formView)
        addSubview(separatorLineView)
        addSubview(verificationView)
        addSubview(verifyButton)
//        addSubview(thirdPartyButtonView1)
//        addSubview(thirdPartyButtonView2)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: formView.topAnchor, constant: -bounds.height * 0.05),

            formView.centerXAnchor.constraint(equalTo: centerXAnchor),
            formView.centerYAnchor.constraint(equalTo: centerYAnchor),
            formView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7656),
            formView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2852),
            
            separatorLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.875),
            separatorLineView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLineView.topAnchor.constraint(equalTo: formView.bottomAnchor, constant: bounds.height * 0.05),
            
            verificationView.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: bounds.height * 0.05),
            verificationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verificationView.widthAnchor.constraint(equalTo: formView.widthAnchor),
            verificationView.heightAnchor.constraint(equalTo: formView.heightAnchor, multiplier: 0.3),
            
            verifyButton.leadingAnchor.constraint(equalTo: verificationView.leadingAnchor),
            verifyButton.topAnchor.constraint(equalTo: verificationView.bottomAnchor, constant: 10),
            verifyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
            
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
