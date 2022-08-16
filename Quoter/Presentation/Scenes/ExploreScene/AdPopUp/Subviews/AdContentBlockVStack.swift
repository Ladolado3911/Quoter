//
//  AdStackView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

struct AdVStackConfiguratorModel {
    var upperContentTitle: String
    var lowerContentInfo: Any
}

final class AdContentBlockVStack: UIStackView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var adContentDelegate: AdContentDelegateProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(delegate: AdContentDelegateProtocol) {
        self.init(frame: .zero)
        adContentDelegate = delegate
        adContentDelegate.rootVStack = self
        titleLabel.text = delegate.configurator?.upperContentTitle
        addArrangedSubview(titleLabel)
        adContentDelegate.configVStack()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        distribution = .fillEqually
        axis = .vertical
    }
    
}
