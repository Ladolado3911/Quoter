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
    func verticalSpacing(collectionView: UICollectionView) -> CGFloat
    func widthForItem(indexPath: IndexPath) -> CGFloat
    func heightOfAllItems(collectionView: UICollectionView) -> CGFloat
}

class FilterLayout: UICollectionViewFlowLayout {
    
    var dataSource: FilterLayoutDataSource?
    var delegate: FilterLayoutDelegate?
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        guard let delegate = delegate else { return .zero }
        guard let collectionView = collectionView else { return .zero }
        
        let heightOfCollectionView = collectionView.bounds.height
        let widthOfCollectionView = collectionView.bounds.width
        let horizontalSpacing = delegate.horizontalSpacing()
        
        var accumulatedWidth: CGFloat = 0
        var accumulatedWidths: [CGFloat] = []
        
        for attributeIndex in 0..<cache.count {
            let attribute = cache[attributeIndex]
            accumulatedWidth = accumulatedWidth + attribute.size.width + horizontalSpacing
            if accumulatedWidth - horizontalSpacing > widthOfCollectionView {
                accumulatedWidths.append(accumulatedWidth)
                accumulatedWidth = 0
            }
        }
        let contentWidth = (accumulatedWidths.max() ?? 0)
        return CGSize(width: contentWidth,
                      height: heightOfCollectionView)
    }
    
    override func prepare() {
        super.prepare()
        guard let delegate = delegate else { return }
        guard let collectionView = collectionView else { return }

        let increment: CGFloat = delegate.horizontalSpacing()
        let verticalIncrement: CGFloat = delegate.verticalSpacing(collectionView: collectionView)
        let numberOfElements = collectionView.numberOfItems(inSection: 0)
        let heightOfAllItems = delegate.heightOfAllItems(collectionView: collectionView)
        var minX: CGFloat = 15
        var currentY: CGFloat = 15
    
        for item in 0..<numberOfElements {
            let indexPath = IndexPath(item: item, section: 0)
            let widthOfItem = delegate.widthForItem(indexPath: indexPath)
            
            if [2, 5, 8].contains(item) {
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let frame = CGRect(x: minX, y: currentY, width: widthOfItem, height: heightOfAllItems)
                attribute.frame = frame
                cache.append(attribute)
                print(verticalIncrement)
                currentY = currentY + heightOfAllItems + verticalIncrement
                minX = 15
                continue
            }
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(x: minX, y: currentY, width: widthOfItem, height: heightOfAllItems)
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
