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
        button.alpha = 0
        return button
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Notification Schedule"
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(headlineLabel)
    }
    
    private func buildConstraints() {
        guard let parentFinalFrame = parentFinalFrame else {
            return
        }
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.045),
            closeButton.heightAnchor.constraint(equalToConstant: PublicConstants.screenHeight * 0.045),
            
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: parentFinalFrame.width / 2 - ((parentFinalFrame.width * 0.6) / 2)),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            headlineLabel.widthAnchor.constraint(equalToConstant: parentFinalFrame.width * 0.6),
            headlineLabel.heightAnchor.constraint(equalToConstant: parentFinalFrame.height * 0.10),
        ])
    }
    
    func buildView() {
        self.closeButton.alpha = 0
        self.headlineLabel.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.closeButton.alpha = 1
            self.headlineLabel.alpha = 1
        }
    }
    
    func demolishView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.closeButton.alpha = 0
            self.headlineLabel.alpha = 0
        } completion: { didFinish in
            if didFinish {
                completion()
            }
        }
    }
}
