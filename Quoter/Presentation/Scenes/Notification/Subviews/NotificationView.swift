//
//  NotificationView.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 3/15/22.
//

import UIKit

class NotificationView: UIView {
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.cornerRadius = 20
        
    }
    
    func buildView() {
//        guard let collectionView = collectionView else {
//            return
//        }
//        self.filterButton.alpha = 0
//        self.mainTitleLabel.alpha = 0
//        self.deselectButton.alpha = 0
//        self.removeFilterButton.alpha = 0
//        self.closeButton.alpha = 0
//        collectionView.alpha = 0
//        collectionView.frame = collectionViewFinalFrame!

//        UIView.animate(withDuration: 0.3) { [weak self] in
//            guard let self = self else { return }
//            self.filterButton.alpha = 1
//            self.mainTitleLabel.alpha = 1
//            self.deselectButton.alpha = 1
//            self.removeFilterButton.alpha = 1
//            self.closeButton.alpha = 1
//            collectionView.alpha = 1
//        }
    }
    
    func demolishView(completion: @escaping () -> Void) {
        completion()
//        guard let collectionView = collectionView else {
//            return
//        }
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            guard let self = self else { return }
//            self.filterButton.alpha = 0
//            self.mainTitleLabel.alpha = 0
//            self.deselectButton.alpha = 0
//            self.removeFilterButton.alpha = 0
//            self.closeButton.alpha = 0
//            collectionView.alpha = 0
//        } completion: { didFinish in
//            if didFinish {
//                completion()
//            }
//        }
    }
    
}
