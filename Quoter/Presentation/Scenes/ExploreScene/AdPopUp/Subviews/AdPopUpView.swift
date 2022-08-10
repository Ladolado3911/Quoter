//
//  AdPopUpView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

protocol AdContentDelegateProtocol: AnyObject {
    func configVStack()
}


final class AdPopUpView: UIView, PopUpViewProtocol {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentHStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .equalSpacing
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    let bookImageView: UIImageView = {
        let bookImageView = UIImageView()
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        return bookImageView
    }()
    
    let infoVStack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.distribution = .equalSpacing
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
    }
    
    private func configView() {
        backgroundColor = .white
        layer.cornerRadius = 20
    }
}
