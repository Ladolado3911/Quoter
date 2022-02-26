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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //titleLabel?.adjustsFontSizeToFitWidth = true
        layer.borderWidth = 1
        layer.cornerRadius = bounds.height * 0.3
        //backgroundColor = .clear
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .disabled)
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
        let width = mainTitleFinalFrame!.width / 2
        let height = mainTitleFinalFrame!.height * 0.8
        let x = bounds.width / 2 + 20
        let y = bounds.height - height - 20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var closeButtonFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let size: CGFloat = PublicConstants.screenHeight * 0.045
        let x: CGFloat = collectionViewFinalFrame!.minX
        let y = (deselectButtonFinalFrame!.minY + deselectButtonFinalFrame!.height / 2) - (size / 2)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        return frame
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close")?.withTintColor(.black), for: .normal)
        button.frame = closeButtonFinalFrame!
        button.alpha = 0
        return button
    }()
    
    lazy var removeFilterButtonFinalFrame: CGRect? = {
        guard let parentFinalFrame = parentFinalFrame else {
            return nil
        }
        let width = mainTitleFinalFrame!.width / 2
        let height = mainTitleFinalFrame!.height * 0.8
        let x = (bounds.width / 2) - 20 - width
        let y = filterButtonFinalFrame!.minY
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
        let x: CGFloat = bounds.width - 20 - width
        let y = mainTitleLabel.frame.minY
        let frame = CGRect(x: x, y: y, width: width, height: height)
        return frame
    }()
    
    lazy var deselectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = deselectButtonFinalFrame!
        //button.isHidden = true
        button.setImage(UIImage(named: "uncheck")?.resizedImage(targetHeight: 35), for: .normal)
        button.setImage(UIImage(named: "checkAll")?.resizedImage(targetHeight: 35), for: .selected)
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
        mainTitleLabel.text = "Filters"
        return mainTitleLabel
    }()
    
    lazy var filterButton: FilterButton = {
        let filterButton = FilterButton(type: .custom)
        filterButton.frame = filterButtonFinalFrame!
        filterButton.setTitle("Add", for: .normal)
        filterButton.isEnabled = false
        filterButton.alpha = 0
        return filterButton
    }()
    
    lazy var removeFilterButton: FilterButton = {
        let removeButton = FilterButton(type: .custom)
        removeButton.frame = removeFilterButtonFinalFrame!
        removeButton.setTitle("Clear", for: .normal)
        removeButton.isEnabled = false
        removeButton.alpha = 0
        return removeButton
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
        addSubview(removeFilterButton)
        addSubview(closeButton)
    }
    
    func buildView() {
        guard let collectionView = collectionView else {
            return
        }
        self.filterButton.alpha = 0
        self.mainTitleLabel.alpha = 0
        self.deselectButton.alpha = 0
        self.removeFilterButton.alpha = 0
        self.closeButton.alpha = 0
        collectionView.alpha = 0
        collectionView.frame = collectionViewFinalFrame!

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterButton.alpha = 1
            self.mainTitleLabel.alpha = 1
            self.deselectButton.alpha = 1
            self.removeFilterButton.alpha = 1
            self.closeButton.alpha = 1
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
            self.removeFilterButton.alpha = 0
            self.closeButton.alpha = 0
            collectionView.alpha = 0
        } completion: { didFinish in
            if didFinish {
                completion()
            }
        }
    }
}
