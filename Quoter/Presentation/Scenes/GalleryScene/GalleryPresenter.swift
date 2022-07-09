//
//  GalleryPresenter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

protocol GalleryPresenterProtocol {
    var vc: GalleryVCProtocol? { get set }
}

class GalleryPresenter: GalleryPresenterProtocol {
    var vc: GalleryVCProtocol?
}
