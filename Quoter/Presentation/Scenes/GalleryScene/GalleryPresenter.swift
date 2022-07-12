//
//  GalleryPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

protocol GalleryPresenterProtocol {
    var vc: GalleryVCProtocol? { get set }
    
    func showInfoLabel()
    func reloadData()
}

class GalleryPresenter: GalleryPresenterProtocol {
    var vc: GalleryVCProtocol?
    
    func showInfoLabel() {
        vc?.showInfoLabel()
    }
    
    func reloadData() {
        vc?.reloadData()
    }
}
