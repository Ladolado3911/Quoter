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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion()
        }
    }
}
