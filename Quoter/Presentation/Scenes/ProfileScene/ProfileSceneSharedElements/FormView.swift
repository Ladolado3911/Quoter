//
//  FormView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/23/22.
//

import UIKit

class FormView: UIView {

    let firstInputView: InputView = {
        let firstInput = InputView(type: .email)
        firstInput.translatesAutoresizingMaskIntoConstraints = false
        return firstInput
    }()
    
    let secondInputView: InputView = {
        let secondInput = InputView(type: .password)
        secondInput.translatesAutoresizingMaskIntoConstraints = false
        return secondInput
    }()
    
    let callToActionButton: CallToActionButton = {
        let ctaButton = CallToActionButton()
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        return ctaButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(formType: FormType) {
        self.init(frame: .zero)
        switch formType {
        case .signUp:
            callToActionButton.callToActionButtonType = .signUp
        case .signIn:
            callToActionButton.callToActionButtonType = .signIn
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(firstInputView)
        addSubview(secondInputView)
        addSubview(callToActionButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            firstInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstInputView.topAnchor.constraint(equalTo: topAnchor),
            
            secondInputView.topAnchor.constraint(equalTo: firstInputView.bottomAnchor, constant: 15),
            secondInputView.leadingAnchor.constraint(equalTo: firstInputView.leadingAnchor),
            secondInputView.trailingAnchor.constraint(equalTo: firstInputView.trailingAnchor),
            secondInputView.heightAnchor.constraint(equalTo: firstInputView.heightAnchor),
            
            callToActionButton.topAnchor.constraint(equalTo: secondInputView.bottomAnchor, constant: 25),
            callToActionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3673),
            callToActionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            callToActionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
