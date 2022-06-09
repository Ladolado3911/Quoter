//
//  FilterLayout.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/9/22.
//

import UIKit

class FilterLayout: UICollectionViewLayout {
    
    override func prepare() {
        super.prepare()
        let increment: CGFloat = 10
        let numberOfElements = numOfItems
        var minX: CGFloat = inset
    
        for item in 0..<numberOfElements {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(x: minX, y: 0, width: itemWidth, height: itemHeight)
            attribute.frame = frame
            let changedAttribute = changeLayoutAttributes(attribute)
            cache.append(changedAttribute)
            minX += increment
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        var copyAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in attributes {
            
        }
        return copyAttributes
    }

}
