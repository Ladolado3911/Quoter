//
//  FilterInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/6/22.
//

import UIKit

enum State {
    case on
    case off
}

protocol FilterInteractorProtocol {
    var presenter: FilterPresenterProtocol? { get set }
    var filterNetworkWorker: FilterNetworkWorkerProtocol? { get set }
    
    var hasSetPointOrigin: Bool { get set }
    var pointOrigin: CGPoint? { get set }
    var backAlphaOrigin: CGFloat? { get set }
    var categories: [Genre] { get set }
    var states: [State] { get set }
    var currentChosenCategory: Genre { get set }
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: FilterView)
    func panFunc2(sender: UIPanGestureRecognizer, targetView: FilterView, backView: UIView, minY: CGFloat, dragVelocity: CGPoint)
    func tapFunc(sender: UITapGestureRecognizer, targetView: UIView)
    func animatedDismiss(delegate: FilterToExploreProtocol?)
    func showView(targetView: FilterView, backView: UIView)
    func selectCell()
    //func hideView()
    
    func widthForItem(indexPath: IndexPath) -> CGFloat
    func heightOfAllItems(collectionView: UICollectionView) -> CGFloat
    
    //MARK: Collection view delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    //MARK: Networking
    func getCategories()
    
}

final class FilterInteractor: FilterInteractorProtocol {
    
    var presenter: FilterPresenterProtocol?
    var filterNetworkWorker: FilterNetworkWorkerProtocol?

    var hasSetPointOrigin: Bool = false
    var pointOrigin: CGPoint?
    var backAlphaOrigin: CGFloat?
    
    var categories: [Genre] = []
    var states: [State] = Array(repeating: .off, count: Genre.allCases.count) {
        didSet {
            if !states.contains(.on) {
                currentChosenCategory = .general
            }
        }
    }
    var currentChosenCategory: Genre = .general {
        didSet {
            presenter?.setCurrentGenreToLabel(genre: currentChosenCategory)
        }
    }
    
    func panFunc(sender: UIPanGestureRecognizer, targetView: FilterView) {
        presenter?.panFunc(sender: sender, targetView: targetView)
    }
    
    func panFunc2(sender: UIPanGestureRecognizer, targetView: FilterView, backView: UIView, minY: CGFloat, dragVelocity: CGPoint) {
        let translation = sender.translation(in: targetView)
        guard translation.y >= 0 else { return }
        targetView.frame.origin = CGPoint(x: -5, y: pointOrigin!.y + translation.y)
        let alpha = 1.1 / ((targetView.frame.minY / targetView.frame.height) * 1) - 1
        backView.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha)
        if sender.state == .ended {
            if dragVelocity.y >= 1300 {
                animatedDismiss(delegate: nil)
            }
            else if minY >= Constants.screenHeight * 0.7  {
                animatedDismiss(delegate: nil)
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    targetView.frame.origin = self.pointOrigin ?? CGPoint(x: -5, y: UIScreen.main.bounds.height * 0.3819)
                    self.presenter?.animateColor()
                }
            }
        }
    }
    
    func tapFunc(sender: UITapGestureRecognizer, targetView: UIView) {
        if sender.location(in: targetView).y < Constants.screenHeight * 0.3819 {
            animatedDismiss(delegate: nil)
        }
    }
    
    func animatedDismiss(delegate: FilterToExploreProtocol?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.presenter?.animateMovement(direction: .down)
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                if let delegate = delegate {
                    delegate.sendBackGenre(genre: self.currentChosenCategory)
                }
                self.presenter?.dismiss()
            }
        }
    }
    
    func showView(targetView: FilterView, backView: UIView) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.presenter?.animateColor()
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.presenter?.animateMovement(direction: .up)
            }
        } completion: { [weak self] didFinish in
            guard let self = self else { return }
            if didFinish {
                self.pointOrigin = targetView.frame.origin
                self.backAlphaOrigin = backView.backgroundColor?.alpha
                self.getCategories()
            }
        }
    }
    
    func selectCell() {
        guard let indexPathInt = categories.enumerated().filter { $0.element == currentChosenCategory }.first?.offset else { return }
        let indexPath = IndexPath(item: indexPathInt, section: 0)
        self.presenter?.selectCell(indexPath: indexPath)
    }
    
    func getCategories() {
        var categories = Genre.allCases
        categories.removeAll { genre in
            genre == .general
        }
        self.categories = categories
        self.presenter?.reloadCollectionViewData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributes = [
            NSAttributedString.Key.font: LibreBaskerville.styles.regular(size: 20)
        ]
        let stringSize = categories[indexPath.item].rawValue.size(withAttributes: attributes)
        let cellSize = CGSize(width: stringSize.width * 2.157,
                              height: stringSize.height * 3)
        return cellSize
    }
    
    func widthForItem(indexPath: IndexPath) -> CGFloat {
        let attributes = [
            NSAttributedString.Key.font: LibreBaskerville.styles.regular(size: 20)
        ]
        let stringSize = categories[indexPath.item].rawValue.size(withAttributes: attributes)
        guard let consequentIcon = categories[indexPath.item].rawValue.getNeededIcon() else { return stringSize.width * 1.8 }
        let cellSize = CGSize(width: stringSize.width * 1.375 + consequentIcon.size.width * 1.375,
                              height: stringSize.height * 3)
        return cellSize.width
    }
    
    func heightOfAllItems(collectionView: UICollectionView) -> CGFloat {
        Constants.screenHeight * 0.0686619
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FilterCell {
            cell.buildSubviews()
            cell.buildConstraints()
            let item = categories[indexPath.item]
            cell.titleLabel.text = item.rawValue.capitalized
            cell.iconImageView.image = item.rawValue.getNeededIcon()?.resizedImage(targetHeight: 30)
            cell.state = states[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = states[indexPath.item]
        switch item {
        case .on:
            states[indexPath.item] = .off
        case .off:
            states[indexPath.item] = .on
        }
        currentChosenCategory = categories[indexPath.item]
        var otherIndexPaths: [IndexPath] = []
        for stateIndex in 0..<states.count {
            if stateIndex != indexPath.item {
                states[stateIndex] = .off
                let otherIndexPath = IndexPath(item: stateIndex, section: 0)
                otherIndexPaths.append(otherIndexPath)
            }
        }
        collectionView.reloadData()
    }
}

