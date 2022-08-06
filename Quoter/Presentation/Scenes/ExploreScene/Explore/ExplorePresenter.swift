//
//  ExplorePresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 5/15/22.
//

import UIKit

protocol ExplorePresenterProtocol {
    var vc: ExploreVCProtocol? { get set }
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath], shouldAddCell: Bool)
    func addCellWhenSwiping(indexPaths: [IndexPath], shouldAddCell: Bool)
    func screenShot()
    func presentAlert(title: String,
                      text: String,
                      mainButtonText: String,
                      mainButtonStyle: UIAlertAction.Style,
                      action: (() -> Void)?)
    
    func presentPickModalAlert(title: String,
                               text: String,
                               mainButtonText: String,
                               mainButtonStyle: UIAlertAction.Style,
                               action: (() -> Void)?)
    func turnLeftArrowOn()
    func reloadCollectionView()
    
    func turnInteractionOn()
    func turnInteractionOff()
    
    func showSignin()
}

final class ExplorePresenter: ExplorePresenterProtocol {
    var vc: ExploreVCProtocol?
    
    func scroll(direction: ExploreDirection, contentOffsetX: CGFloat, indexPaths: [IndexPath], shouldAddCell: Bool) {
        vc?.scroll(direction: direction, contentOffsetX: contentOffsetX, indexPaths: indexPaths, shouldAddCell: shouldAddCell)
    }
    
    func addCellWhenSwiping(indexPaths: [IndexPath], shouldAddCell: Bool) {
        vc?.addCellWhenSwiping(indexPaths: indexPaths, shouldAddCell: shouldAddCell)
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
    
    func presentPickModalAlert(title: String,
                               text: String,
                               mainButtonText: String,
                               mainButtonStyle: UIAlertAction.Style,
                               action: (() -> Void)?) {
        
        vc?.presentPickModalAlert(title: title,
                                  text: text,
                                  mainButtonText: mainButtonText,
                                  mainButtonStyle: mainButtonStyle,
                                  action: action)
    }
    
    func reloadCollectionView() {
        vc?.reloadCollectionView()
    }
    
    func turnLeftArrowOn() {
        vc?.turnLeftArrowOn()
    }
    
    func turnInteractionOn() {
        vc?.turnInteractionOn()
    }
    func turnInteractionOff() {
        vc?.turnInteractionOff()
    }
    
    func showSignin() {
        vc?.showSignin()
    }
}
