//
//  GalleryRouter.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

protocol GalleryRouterProtocol {
    var vc: GalleryVCProtocol? { get set }
    
    func routeToGallerySubScene(quoteContent: String?, authorName: String?, imageURLString: String?)
}

class GalleryRouter: GalleryRouterProtocol {
    weak var vc: GalleryVCProtocol?
    
    func routeToGallerySubScene(quoteContent: String?, authorName: String?, imageURLString: String?) {
        let gallerySubSceneVC = GallerySubSceneVC()
        gallerySubSceneVC.quoteContent = quoteContent
        gallerySubSceneVC.authorName = authorName
        gallerySubSceneVC.imageURLString = imageURLString
        gallerySubSceneVC.modalTransitionStyle = .crossDissolve
        gallerySubSceneVC.modalPresentationStyle = .overCurrentContext
        vc?.present(vc: gallerySubSceneVC)
    }
}
