//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import SnapKit
import TTGTags

class FilterView: UIView {
    
    var collectionView: TTGTextTagCollectionView?
    var parentFinalFrame: CGRect?
    
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
    
    lazy var mainTitleFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = parentFinalFrame.width * 0.95
        let height = parentFinalFrame.height * 0.10
        let x = parentFinalFrame.width / 2 - (width / 2)
        let y: CGFloat = 15
        let titleFrame = CGRect(x: x, y: y, width: width, height: height)
        return titleFrame
    }()
    
    lazy var filterButtonFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = mainTitleFinalFrame!.width
        let height = mainTitleFinalFrame!.height
        let x = mainTitleFinalFrame!.minX
        let y = bounds.height - height - 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var collectionViewFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = mainTitleFinalFrame!.width
        let height = (bounds.height - (mainTitleFinalFrame!.height + filterButtonFinalFrame!.height)) * 0.8
        let x = mainTitleFinalFrame!.minX
        let y = mainTitleFinalFrame!.maxY + 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var mainTitleLabel: UILabel = {
        let mainTitleLabel = UILabel(frame: mainTitleFinalFrame!)
        mainTitleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        mainTitleLabel.textColor = .black
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.numberOfLines = 2
        mainTitleLabel.alpha = 0
        mainTitleLabel.text = "Interest Tags"
        return mainTitleLabel
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .custom)
        filterButton.frame = filterButtonFinalFrame!
        filterButton.setTitle("Filter", for: .normal)
        filterButton.layer.borderWidth = 1
        filterButton.layer.cornerRadius = 20
        filterButton.backgroundColor = .clear
        filterButton.layer.borderColor = UIColor.black.cgColor
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.white, for: .selected)
        filterButton.alpha = 0
        return filterButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        buildSubviews()
    }
    
    private func buildSubviews() {
        addSubview(mainTitleLabel)
        addSubview(filterButton)
    }
    
    func buildView() {
        guard let collectionView = collectionView else {
            return
        }
        self.filterButton.alpha = 0
        self.mainTitleLabel.alpha = 0
        collectionView.alpha = 0
        collectionView.frame = collectionViewFinalFrame!

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterButton.alpha = 1
            self.mainTitleLabel.alpha = 1
            collectionView.alpha = 1
        }
    }
    
    func demolishView(completion: @escaping () -> Void) {
        guard let collectionView = collectionView else {
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterButton.alpha = 0
            self.mainTitleLabel.alpha = 0
            collectionView.alpha = 0
        } completion: { didFinish in
            if didFinish {
                completion()
            }
        }
    }
}
