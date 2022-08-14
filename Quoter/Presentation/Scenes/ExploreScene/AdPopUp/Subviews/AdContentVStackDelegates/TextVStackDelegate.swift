//
//  File.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class TextVStackDelegate: AdContentDelegateProtocol {
    
    var rootVStack: UIStackView?
    var configurator: AdVStackConfiguratorModel?
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(configurator: AdVStackConfiguratorModel) {
        self.configurator = configurator
    }

    func configVStack() {
        if let lowerContent = configurator?.lowerContentInfo as? String {
            contentLabel.text = lowerContent
        }
        rootVStack!.addArrangedSubview(contentLabel)
    }
}
