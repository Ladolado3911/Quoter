//
//  FilterLayout.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/9/22.
//

import UIKit

protocol FilterLayoutDataSource {
    //func numOfItems() -> Int
//    func horizontalSpacing() -> CGFloat
//    func verticalSpacing() -> CGFloat
//    func sizeForItem() -> CGSize
}

protocol FilterLayoutDelegate {
    func horizontalSpacing() -> CGFloat
    func verticalSpacing() -> CGFloat
    func widthForItem(indexPath: IndexPath) -> CGFloat
    func heightOfAllItems() -> CGFloat
}

class FilterLayout: UICollectionViewLayout {
    
    var dataSource: FilterLayoutDataSource?
    var delegate: FilterLayoutDelegate?
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        //guard let dataSource = dataSource else { return .zero }
        guard let delegate = delegate else { return .zero }
        guard let collectionView = collectionView else { return .zero }
        
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        let heightOfAllItems = delegate.heightOfAllItems()
        let heightOfCollectionView = collectionView.bounds.height
        let widthOfCollectionView = collectionView.bounds.width
        let horizontalSpacing = delegate.horizontalSpacing()
        
        let contentWidth = cache.compactMap { $0.size.width / 2 }.reduce(0, +) + (horizontalSpacing * (itemsCount - 1))
        
        return CGSize(width: contentWidth,
                      height: heightOfCollectionView)
    }
    
    override func prepare() {
        super.prepare()
        //guard let dataSource = dataSource else { return }
        guard let delegate = delegate else { return }

        let increment: CGFloat = delegate.horizontalSpacing()
        let numberOfElements = collectionView?.numberOfItems(inSection: 0) ?? 0
        let heightOfAllItems = delegate.heightOfAllItems()
        var minX: CGFloat = 0
    
        for item in 0..<numberOfElements {
            let indexPath = IndexPath(item: item, section: 0)
            let widthOfItem = delegate.widthForItem(indexPath: indexPath)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(x: minX, y: 0, width: widthOfItem, height: heightOfAllItems)
            attribute.frame = frame
            cache.append(attribute)
            minX = minX + increment + widthOfItem
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultAttributes: [UICollectionViewLayoutAttributes] = []
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                resultAttributes.append(attribute)
            }
        }
        return resultAttributes
    }

}
