//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import SnapKit

class FilterView: UIView {
    
    var collectionView: UICollectionView?
    
    lazy var mainTitleLabel: UILabel = {
        let width = bounds.width * 0.95
        let height = bounds.height * 0.19523
        let x = bounds.width / 2 - (width / 2)
        let y: CGFloat = 15
        let titleFrame = CGRect(x: x, y: y, width: width, height: height)
        let mainTitleLabel = UILabel(frame: titleFrame)
        mainTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        mainTitleLabel.textColor = .black
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.numberOfLines = 2
        return mainTitleLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        buildSubviews()
        buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainTitleLabel)
        if let collectionView = collectionView {
            addSubview(collectionView)
        }
    }
    
    private func buildConstraints() {
        if let collectionView = collectionView {
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(mainTitleLabel.snp.bottom).inset(20)
            }
        }
    }
}
