//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExplorePresenterProtocol {
    var vc: ExploreVCProtocol? { get set }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath])
    func addCellWhenSwiping(indexPaths: [IndexPath])
    func screenShot()
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: (() -> Void)?)
}

class ExplorePresenter: ExplorePresenterProtocol {
    var vc: ExploreVCProtocol?
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath]) {
        vc?.scroll(direction: direction, contentOffsetX: contentOffsetX, indexPaths: indexPaths)
    }
    
    func addCellWhenSwiping(indexPaths: [IndexPath]) {
        vc?.addCellWhenSwiping(indexPaths: indexPaths)
    }
    
    func screenShot() {
        vc?.screenshot()
    }
    
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: (() -> Void)?) {
        vc?.presentAlert(title: title,
                         text: text,
                         mainButtonText: mainButtonText,
                         mainButtonStyle: mainButtonStyle,
                         action: action)
    }
}
