//
//  UICollectionView+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/14/22.
//

import UIKit

extension UICollectionView {
    func reloadData(_ completion: @escaping () -> Void) {
        reloadData()
        completion()
    }

    func pickRelevantCellObject(using manager: CellsManagerProtocol) -> CellProtocol? {
        for object in manager.everyCellObjects.flatMap({ $0 }) {
            if self == object.innerCollectionView {
                return object
            }
        }
        return nil
    }
}
