//
//  File.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

final class TextVStackDelegate: AdContentDelegateProtocol {
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var rootVStack: UIStackView!
    
    init(rootVStack: UIStackView) {
        self.rootVStack = rootVStack
    }
    
    func configVStack() {
        rootVStack.addArrangedSubview(contentLabel)
    }
}
