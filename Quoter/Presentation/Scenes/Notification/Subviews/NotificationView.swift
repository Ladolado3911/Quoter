//
//  NotificationView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

class NotificationView: UIView {
    
    var parentFinalFrame: CGRect?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close")?.withTintColor(.black), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.frame = closeButtonFinalFrame!
        button.alpha = 0
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, finalFrame: CGRect) {
        self.init(frame: frame)
        self.parentFinalFrame = finalFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(closeButton)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.045),
            closeButton.heightAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.045),
        ])
    }
    
    func buildView() {
        self.closeButton.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.closeButton.alpha = 1
        }
    }
    
    func demolishView(completion: @escaping () -> Void) {
        //completion()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.closeButton.alpha = 0
        } completion: { didFinish in
            if didFinish {
                completion()
            }
        }
    }
}
