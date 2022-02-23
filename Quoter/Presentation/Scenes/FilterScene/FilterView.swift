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
    
    lazy var mainTitleFinalFrame: CGRect = {
        let width = bounds.width * 0.95
        let height = bounds.height * 0.19523
        let x = bounds.width / 2 - (width / 2)
        let y: CGFloat = 15
        let titleFrame = CGRect(x: x, y: y, width: width, height: height)
        return titleFrame
    }()
    
    lazy var filterButtonFinalFrame: CGRect = {
        let width = mainTitleFinalFrame.width
        let height = mainTitleFinalFrame.height
        let x = mainTitleFinalFrame.minX
        let y = bounds.height - height - 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var collectionViewFinalFrame: CGRect = {
        let width = mainTitleFinalFrame.width
        let height = (bounds.height - (mainTitleFinalFrame.height + filterButtonFinalFrame.height)) * 0.8
        let x = mainTitleFinalFrame.minX
        let y = mainTitleFinalFrame.maxY + 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel(frame: initialFrame)
        mainTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        mainTitleLabel.textColor = .black
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.numberOfLines = 2
        mainTitleLabel.alpha = 0
        return mainTitleLabel
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .custom)
        filterButton.frame = initialFrame
        filterButton.setTitle("Filter", for: .normal)
        filterButton.layer.borderWidth = 1
        filterButton.layer.cornerRadius = 20
        filterButton.backgroundColor = .clear
        filterButton.layer.borderColor = UIColor.black.cgColor
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.alpha = 0
        return filterButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        buildSubviews()
        //buildView()
        //buildConstraints()
    }
    
    private func buildSubviews() {
        addSubview(mainTitleLabel)
        addSubview(filterButton)
    }
    
    func buildView() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView.frame = initialFrame
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            collectionView.frame = self.collectionViewFinalFrame
            self.filterButton.frame = self.filterButtonFinalFrame
            self.mainTitleLabel.frame = self.mainTitleFinalFrame
            self.filterButton.alpha = 1
            self.mainTitleLabel.alpha = 1
            collectionView.alpha = 1
        }
    }
}
