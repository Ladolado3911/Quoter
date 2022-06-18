//
//  UITableView+Extension.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 6/18/22.
//

import UIKit

extension UITableView {
    func registerCells(using manager: CellsManagerProtocol, target: UIViewController) {
        for object in manager.everyCellObjects.flatMap({ $0 }) {
            object.registerCell(self)
            object.configureInnerCollectionView(target: target)
        }
    }
//    
//    func dequeCell(using manager: CellsManagerProtocol) {
//        
//    }
}
