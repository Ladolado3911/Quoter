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


final class AdPopUpView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Fonts.businessFonts.libreBaskerville.bold(size: 25)
        label.textColor = DarkModeColors.mainBlack
        label.text = "The book Elon Musk recommends"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentHStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fillEqually
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    let bookImageView: UIImageView = {
        let bookImageView = UIImageView()
        bookImageView.image = UIImage(named: "hitchhiker")
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        return bookImageView
    }()
    
    let infoVStack: UIStackView = {
        let vstack = UIStackView()
        vstack.isLayoutMarginsRelativeArrangement = true
        vstack.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        vstack.axis = .vertical
        vstack.distribution = .fillEqually
        vstack.backgroundColor = .white
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let textVStack: AdContentBlockVStack = {
        let vstack = AdContentBlockVStack(delegate: TextVStackDelegate(configurator: AdVStackConfiguratorModel(upperContentTitle: "Title:", lowerContentInfo: "test Title")))
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    let ratingVStack: AdContentBlockVStack = {
        let delegate = RatingVStackDelegate(configurator: AdVStackConfiguratorModel(upperContentTitle: "Rating:", lowerContentInfo: 4.5))
        let vstack = AdContentBlockVStack(delegate: delegate)
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            contentHStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            contentHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            contentHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            bookImageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.5),

        ])
    }
}
