//
//  GalleryInteractor.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 7/9/22.
//

import UIKit
import SDWebImage

protocol GalleryInteractorProtocol {
    var presenter: GalleryPresenterProtocol? { get set }
    var galleryNetworkWorker: GalleryNetworkWorkerProtocol? { get set }
    
    var userQuotes: [SavedQuote] { get set }
    
    func setUserQuotes()
    
    //MARK: Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
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
                if self.userQuotes.isEmpty {
                    self.presenter?.showInfoLabel()
                }
                else {
                    self.presenter?.reloadData()
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userQuotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GalleryCell {
            let currentQuote = userQuotes[indexPath.item]
            let url =  URL(string: currentQuote.image.imageURLString)
            cell.buildSubviews()
            cell.buildConstraints()
            cell.titleLabel.text = currentQuote.quote.author.name.capitalized
            cell.imageView.sd_setImage(with: url, placeholderImage: nil, options: [.highPriority], context: nil, progress: nil) { image, error, cacheType, url in
                if let error = error {
                    print("image errpr: \(error)")
                    
                }
            }
//            if let url = URL(string: currentQuote.image.imageURLString) {
//                cell.imageView.sd_setImage(with: url)
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.screenWidth * 0.308,
               height: Constants.screenWidth * 0.308 * 1.6125)
    }
}


