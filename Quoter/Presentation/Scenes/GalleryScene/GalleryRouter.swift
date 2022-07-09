//
//  GalleryRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

protocol GalleryRouterProtocol {
    var vc: GalleryVCProtocol? { get set }
}

class GalleryRouter: GalleryRouterProtocol {
    weak var vc: GalleryVCProtocol?
}
