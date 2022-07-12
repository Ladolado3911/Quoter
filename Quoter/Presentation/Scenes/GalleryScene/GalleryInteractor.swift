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
    
    var userQuotes: [SavedQuote] { get set }
    
    func setUserQuotes()
}

class GalleryInteractor: GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol?
    var galleryNetworkWorker: GalleryNetworkWorkerProtocol?
    
    var userQuotes: [SavedQuote] = []
    
    func setUserQuotes() {
        let userType = CurrentUserLocalManager.shared.type!
        let userIDString = CurrentUserLocalManager.shared.getCurrentUserID()!
        Task.init { [weak self] in
            guard let self = self else { return }
            let savedQuotes = try await self.galleryNetworkWorker?.getUserQuotes(userIDString: userIDString, userType: userType)
            await MainActor.run {
                self.userQuotes = savedQuotes!
                print(self.userQuotes)
            }
            
        }
    }
}


