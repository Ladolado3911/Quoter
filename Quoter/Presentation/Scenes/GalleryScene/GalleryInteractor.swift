//
//  GalleryInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit

protocol GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol? { get set }
    var galleryNetworkWorker: GalleryNetworkWorkerProtocol? { get set }
    
    var capturedQuotes: []
}

class GalleryInteractor: GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol?
    var galleryNetworkWorker: GalleryNetworkWorkerProtocol?
}


