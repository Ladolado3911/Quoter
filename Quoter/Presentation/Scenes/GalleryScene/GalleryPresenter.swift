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
    func didSelect(savedQuote: SavedQuote)
}

class GalleryPresenter: GalleryPresenterProtocol {
    var vc: GalleryVCProtocol?
    
    func showInfoLabel() {
        vc?.showInfoLabel()
    }
    
    func reloadData() {
        vc?.reloadData()
    }
    
    func didSelect(savedQuote: SavedQuote) {
        let content = savedQuote.quote.content
        let name = savedQuote.quote.author.name
        let imageURLString = savedQuote.image.imageURLString
        vc?.didSelect(quoteContent: content, authorName: name, imageURLString: imageURLString)
    }
}
