//
//  FilterView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 2/22/22.
//

import UIKit
import SnapKit
import TTGTags

class FilterButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .black
            }
            else {
                backgroundColor = .white
            }
        }
    }
}

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
        let width = parentFinalFrame.width * 0.6
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
        let width = mainTitleFinalFrame!.width * 1.2
        let height = mainTitleFinalFrame!.height
        let x = bounds.width / 2 - (width / 2)
        let y = bounds.height - height - 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var collectionViewFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = mainTitleFinalFrame!.width * 1.5
        let height = (bounds.height - (mainTitleFinalFrame!.height + filterButtonFinalFrame!.height)) * 0.8
        let x = bounds.width / 2 - (width / 2)
        let y = mainTitleFinalFrame!.maxY + 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var deselectButtonFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = mainTitleFinalFrame!.width / 3
        let height = mainTitleLabel.bounds.height
        let x: CGFloat = 5
        let y = mainTitleLabel.frame.minY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var deselectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = deselectButtonFinalFrame!
        button.isHidden = true
        button.setImage(UIImage(named: "uncheck")?.resizedImage(targetHeight: 35), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.alpha = 0
        return button
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
    
    lazy var filterButton: FilterButton = {
        let filterButton = FilterButton(type: .custom)
        filterButton.frame = filterButtonFinalFrame!
        filterButton.setTitle("Filter", for: .normal)
        filterButton.layer.borderWidth = 1
        filterButton.layer.cornerRadius = 20
        filterButton.backgroundColor = .clear
        filterButton.layer.borderColor = UIColor.black.cgColor
        filterButton.setTitleColor(.white, for: .normal)
        //filterButton.view
        filterButton.setTitleColor(.black, for: .disabled)
        filterButton.isEnabled = false
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
        addSubview(deselectButton)
    }
    
    func buildView() {
        guard let collectionView = collectionView else {
            return
        }
        self.filterButton.alpha = 0
        self.mainTitleLabel.alpha = 0
        self.deselectButton.alpha = 0
        collectionView.alpha = 0
        collectionView.frame = collectionViewFinalFrame!

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterButton.alpha = 1
            self.mainTitleLabel.alpha = 1
            self.deselectButton.alpha = 1
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
            self.deselectButton.alpha = 0
            collectionView.alpha = 0
        } completion: { didFinish in
            if didFinish {
                completion()
            }
        }
    }
}
