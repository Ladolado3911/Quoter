//
//  AdPopUpView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/10/22.
//

import UIKit

protocol AdContentDelegateProtocol: AnyObject {
    var rootVStack: UIStackView? { get set }
    var configurator: AdVStackConfiguratorModel? { get set }
    
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
    
    let textVStack: AdContentBlockVStack = {
        let vstack = AdContentBlockVStack(delegate: TextVStackDelegate(configurator: AdVStackConfiguratorModel(upperContentTitle: "Title:", lowerContentInfo: "test Title")))
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let ratingVStack: AdContentBlockVStack = {
        let vstack = AdContentBlockVStack(delegate: RatingVStackDelegate(configurator: AdVStackConfiguratorModel(upperContentTitle: "Rating:", lowerContentInfo: 4.5)))
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let descVStack: AdContentBlockVStack = {
        let vstack = AdContentBlockVStack(delegate: TextVStackDelegate(configurator: AdVStackConfiguratorModel(upperContentTitle: "Description", lowerContentInfo: "test Desc")))
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
    }
    
    private func configView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(titleLabel)
        infoVStack.addArrangedSubview(textVStack)
        infoVStack.addArrangedSubview(ratingVStack)
        infoVStack.addArrangedSubview(descVStack)
        contentHStack.addArrangedSubview(bookImageView)
        contentHStack.addArrangedSubview(infoVStack)
        addSubview(contentHStack)
    }
    
    private func buildConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
