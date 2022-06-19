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
    var rowsCount: Int = 0
    
    override var collectionViewContentSize: CGSize {
        guard let delegate = delegate else { return .zero }
        guard let collectionView = collectionView else { return .zero }
        let widthOfCollectionView = collectionView.bounds.width
        let heightOfItem: CGFloat = delegate.heightOfAllItems(collectionView: collectionView)
        let verticalSpacing = delegate.verticalSpacing(collectionView: collectionView)
        let contentHeight = CGFloat(rowsCount) * (heightOfItem + verticalSpacing) / 2
        return CGSize(width: widthOfCollectionView,
                      height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        guard let delegate = delegate else { return }
        guard let collectionView = collectionView else { return }

        let collectionViewWidth = collectionView.bounds.width
        let increment: CGFloat = delegate.horizontalSpacing()
        let verticalIncrement: CGFloat = delegate.verticalSpacing(collectionView: collectionView)
        let numberOfElements = collectionView.numberOfItems(inSection: 0)
        let heightOfAllItems = delegate.heightOfAllItems(collectionView: collectionView)
        var minX: CGFloat = 15
        var currentY: CGFloat = 15
        
        var widthsOfItems: [CGFloat] = []
        var accumulatedWidth: CGFloat = 0
        
        var minXesForRows: [CGFloat] = []
        var itemCounts: [Int] = []
        
        var itemCounter = 0
        
        // populate minXes and widths
        for item in 0..<numberOfElements {
            itemCounter += 1
            let indexPath = IndexPath(item: item, section: 0)
            let widthOfItem = delegate.widthForItem(indexPath: indexPath)
            widthsOfItems.append(widthOfItem)
            accumulatedWidth = accumulatedWidth + widthOfItem + increment
            if accumulatedWidth + increment + widthOfItem > collectionViewWidth {
                minX = (collectionViewWidth - accumulatedWidth + increment) / 2
                minXesForRows.append(minX)
                itemCounts.append(itemCounter)
                itemCounter = 0
                accumulatedWidth = 0
                rowsCount += 1
            }
            
        }
        
        var widthsIndex = 0
        for minXRowIndex in 0..<minXesForRows.count {
            var minX = minXesForRows[minXRowIndex]
            for _ in 0..<itemCounts[minXRowIndex] {
                let indexPath = IndexPath(item: widthsIndex, section: 0)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let width = widthsOfItems[widthsIndex]
                let frame = CGRect(x: minX, y: currentY, width: width, height: heightOfAllItems)
                attribute.frame = frame
                cache.append(attribute)
                minX = minX + width + increment
                widthsIndex += 1
            }
            currentY = currentY + heightOfAllItems + verticalIncrement
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
