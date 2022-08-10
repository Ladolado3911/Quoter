//
//  AdStackView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class AdContentBlockVStack: UIStackView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private weak var adContentDelegate: AdContentDelegateProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(delegate: AdContentDelegateProtocol) {
        self.init(frame: .zero)
        adContentDelegate = delegate
        adContentDelegate.configVStack()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        distribution = .equalSpacing
        axis = .vertical
    }
    
}
